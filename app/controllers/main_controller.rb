class MainController < ApplicationController

	def index
		render action: :index
	end

	def espacio
		render action: :espacio
	end

	def products_by_category
		if params[:category_id].present?
			res = API.getProductsByCategory(categoria_id: params[:category_id])

			if !res.nil?
				render json: {productos: res}

			else
				# Hubo un error al obtener los productos de la categoria.
				render json: {msg: "Hubo un error en obtener los productos de la categoria '#{params[:category_id]}'"}, status: :unprocessable_entity
						
			end		
		else
			# No se hay id de categoria.
			render json: {msg: "El servidor no recibió el id de la categoria."}, status: :unprocessable_entity
		end
	end
end
