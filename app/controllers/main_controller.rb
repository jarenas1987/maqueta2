class MainController < ApplicationController
	CATEGORIES_TYPES = {
		muro: 'muro',
		piso: 'piso'
	}

	def index
		render action: :index
	end

	def espacio
		render action: :espacio, locals: {categories_types: CATEGORIES_TYPES}
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
		if !params[:muro].nil? && !params[:piso].nil?
			render json: {}							
		else
			render json: {msg: "Tiene que seleccionar un muro y un piso."}, status: :unprocessable_entity
		end
	end

end
