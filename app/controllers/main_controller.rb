class MainController < ApplicationController
	around_filter :protect_request, only: [:products_by_category, :carrito_add, :set_background, :carrito_send]
	
	CATEGORIES_TYPES = {
		muro: 'muro',
		piso: 'piso'
	}
	PDF_TEMP_FILE = Rails.root.join('tmp', 'prueba.pdf')

	def index
		render action: :index
	end

	def espacio
		carrito = Carrito.new
		# carrito.items << ProductPair.new(piso: Product.new(sku: "1"), muro: Product.new(sku: "2"))
		# carrito.items << ProductPair.new(piso: Product.new(sku: "3"), muro: Product.new(sku: "4"))
		render action: :espacio, locals: {categories_types: CATEGORIES_TYPES, carrito: carrito}
	end

	def products_by_category
		if params[:category_type].present?
			if params[:category_id].present?
				items = API.getProductsByCategory(categoria_id: params[:category_id], category_type: params[:category_type])

				if !items.nil?
					html_item_arr = []
					items.each_with_index do |item, index|
						html_item_arr << render_to_string(partial: 'carousel_items', formats: [:html], layout: false, locals: {item: item, type: Product.new, index: index})
					end

					render json: {
						carousel_items: html_item_arr,
						carousel_type: params[:category_type]
					}

				else
					# Hubo un error al obtener los productos de la categoria.
					render json: {msg: "Hubo un error en obtener los productos de la categoria '#{params[:category_id]}'"}, status: :unprocessable_entity
							
				end		
			else
				# No hay id de categoria.
				render json: {msg: "El servidor no recibió el id de la categoria."}, status: :unprocessable_entity
			end
		else
			# No hay tipo de categoria.
			render json: {msg: "El servidor no recibió el tipo de la categoria."}, status: :unprocessable_entity
		end
	end

	def carrito_add
		if !params[:product].nil?
			carrito_obj = Carrito.new
			product_obj = Product.new(params[:product])
			carrito_obj.items << product_obj
			carrito_obj.calculateTotal

			render json: {
				carrito_item: render_to_string(partial: 'carrito_form', formats: [:html], layout: false, locals: {carrito: carrito_obj}),
				item_sku: product_obj.sku,
				precio_total_item: carrito_obj.total
			}
		else
			render json: {msg: "Hubo problemas en enviar los datos del producto al servidor"}, status: :unprocessable_entity
		end
	end

	def carrito_send
		if !params[:items].nil?
			if params[:email].present?
				# Verificar el formato del email ingresado.
				if params[:email] =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
					pdf_options = {pisos: [], muros: []}

					# Recorrer los pisos y muros para obtener su ficha y asi poder generar el PDF.
					params[:items].each do |item|
						product_obj = API.getFichaProductoBySku(item[:sku], item[:tipo])
						if !product_obj.nil?
							if product_obj.tipo == :piso
								pdf_options[:pisos] << product_obj
							elsif product_obj.tipo == :muro
								pdf_options[:muros] << product_obj
							end
						end
					end

					# Crear PDF.
					pdf = Pdf.new(pdf_options)

					# Guardar el archivo PDF en local.
			    pdf.render_file(PDF_TEMP_FILE.to_s)

			    # Enviar el email con el PDF.
					PdfMailer.pdf_email(params[:email], PDF_TEMP_FILE.to_s).deliver_later

					render json: {msg: "Email enviado a #{params[:email]} con el pdf generado exitosamente.", home_url: root_path}
					
				else
					render json: {msg: "El formato del email ingresado no es válido."}, status: :unprocessable_entity
				end
			else
				render json: {msg: "No hay email."}, status: :unprocessable_entity
			end
		else
			render json: {msg: "El carrito de compras esta vacio."}, status: :unprocessable_entity
		end
	end

	def set_background
		if params[:category_type].present?
			if params[:product_sku].present?
				product_obj = API.getFichaProductoBySku(params[:product_sku], params[:category_type])

				# Verificar que el objeto tenga la imagen a setear.
				if product_obj.img_url.present?
					# Correr el comando para setear la imagen.
					res = system("wallpaper #{product_obj.img_url}")
					
					if res
						render json: {msg: "Imagen de producto seteada exitosamente."}
					else
						render json: {msg: "Hubo un problema en setear la imagen."}, status: :unprocessable_entity
					end
				end
			else
				render json: {msg: "No llego el sku del producto al servidor."}, status: :unprocessable_entity
			end
		else
			render json: {msg: "No llego el tipo de producto al servidor."}, status: :unprocessable_entity
		end
	end


	def protect_request
		begin
			yield
		rescue StandardError => e
			puts e
			puts e.backtrace
			render json: {msg: "Ha ocurrido un error con el request."}, status: :unprocessable_entity
		end
	end	

end
