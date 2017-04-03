class MainController < ApplicationController
	around_filter :protect_request, only: [:products_by_category, :carrito_add]
	
	CATEGORIES_TYPES = {
		muro: 'muro',
		piso: 'piso'
	}

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
				items = API.getProductsByCategory(categoria_id: params[:category_id])

				if !items.nil?
					html_item_arr = []
					items.each_with_index do |item, index|
						html_item_arr << render_to_string(partial: 'carousel_items', formats: [:html], layout: false, locals: {item: item, type: params[:category_type], index: index})
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
		if !params[:piso].nil? && !params[:muro].nil? && !params[:muro][:sku].nil? && !params[:piso][:sku].nil?
			carrito_obj = Carrito.new
			product_pair_obj = ProductPair.new(
				piso: Product.new(params[:piso]),
				muro: Product.new(params[:muro])
			)
			carrito_obj.items << product_pair_obj
			carrito_obj.calculateTotal

			render json: {
				carrito_item: render_to_string(partial: 'carrito_form', formats: [:html], layout: false, locals: {carrito: carrito_obj}),
				piso_sku: product_pair_obj.piso.sku,
				muro_sku: product_pair_obj.muro.sku,
				precio_total_item: carrito_obj.total
			}

		else
			render json: {msg: "Tiene que seleccionar un muro y un piso."}, status: :unprocessable_entity
		end
	end

	def carrito_send
		if !params[:items].nil?
			# Enviar email con el pdf?...

			render json: {}
		else
			render json: {msg: "El carrito de compras esta vacio."}, status: :unprocessable_entity
		end
	end


	def protect_request
		begin
			yield
		rescue StandardError => e
			render json: {msg: "Ha ocurrido un error con el request."}, status: :unprocessable_entity
		end
	end	

end
