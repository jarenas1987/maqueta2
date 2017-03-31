class API
	# Codigos de pisos de la API.
	CATEGORIES = [
		'scat102690',
		'scat552404',
		'scat991120',
		'cat2880013',
		'scat552357',
		'scat880433'
	]

	def self.getProductsByCategory(params)
		# A REVISAR:
		# Cambiar el get_params[:categoria_id] de array a string, en caso de que no se quiera obtener todos los productos de todas las categorias.
		get_params = {categoria_id: [params[:categoria_id]]}

		# if params[:categoria_id] == :all
		# 	get_params[:categoria_id] = CATEGORIES
		# else
		# 	# Se entrega un unico categoria_id, se busca en el array de categorias.
		# 	get_params[:categoria_id] = [params[:categoria_id]] if CATEGORIES.include?(params[:categoria_id])
		# end

		if get_params[:categoria_id].size != 0
			products = []
			offset = 0

			# Recorrer el o los codigos de piso.
			get_params[:categoria_id].each do |categoria_id|
				# TEMPORAL:
				# Para traer todos productos, hay que variar cada 10 el offset de la URL hasta no encontrar mas productos.
				res = JSON.parse(HTTP.get("http://api-car.azurewebsites.net:80/Categories/CL/79/#{categoria_id}?orderBy=2&offset=#{offset}&limit=10").to_s)

				res["products"].each do |product|
					product_obj = Product.new(
						nombre: product["name"],
						sku: product["sku"],
						img_url: product["multimedia"].first["url"]
						)

					# Si el producto cumple las validaciones de la clase, se incluye.
					if product_obj.valid?
						products << product_obj
					end
				end # each product
			end # each categoria_id

			return products
		else
			return nil
		end

	end
	
end
