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

	TIENDA_NUM = 79

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
				products_api_url = JSON.parse(HTTP.get("http://api-car.azurewebsites.net:80/Categories/CL/#{TIENDA_NUM}/#{categoria_id}?orderBy=2&offset=#{offset}&limit=10").to_s)

				# En caso de que la request tenga algun problema en su respuesta.
				if !products_api_url["products"].nil?
					products_api_url["products"].each do |product|
						product_obj = Product.new(
							nombre: product["name"],
							sku: product["sku"],
							img_url: product["multimedia"].first["url"],
							descripcion: getDescriptionFromApi(product),
							precio: product["price"]["normal"],
							tipo: params[:category_type]
							)

						# Realizar llamado de la ficha tecnica del producto.
						ficha_api_url = JSON.parse(HTTP.get("http://api-car.azurewebsites.net/Products/CL/#{TIENDA_NUM}/#{product_obj.sku}/Sheet"))

						if ficha_api_url.kind_of?(Array)
							# Si el llamado devuelve un array es porque no hubo un problema con el llamado
							# Se recorre la lista de atributos del producto hasta encontrar el de "rendimiento por caja"
							ficha_api_url[0]["attributes"].each do |attr|
								if attr["name"] =~ /rendimiento/i
									product_obj.rend_caja = attr["value"]
									break
								end
							end
						end


						# Si el producto cumple las validaciones de la clase, se incluye.
						if product_obj.valid?
							products << product_obj
						end
					end
				end # each product
			end # each categoria_id

			return products
		else
			return nil
		end

	end

	def self.getFichaProductoBySku(sku, tipo)
		if sku.present?
			ficha_producto_api = JSON.parse(HTTP.get("http://api-car.azurewebsites.net/Products/CL/#{TIENDA_NUM}/#{sku}").to_s)

			if ficha_producto_api.kind_of?(Array)
				product_obj = Product.new(
					nombre: ficha_producto_api[0]["name"],
					sku: ficha_producto_api[0]["sku"],
					img_url: ficha_producto_api[0]["multimedia"].first["url"],
					descripcion: getDescriptionFromApi(ficha_producto_api[0]),
					precio: ficha_producto_api[0]["price"]["normal"],
					tipo: tipo,
					rend_caja: '-'
				)

				if product_obj.valid?
					return product_obj
				else
					return nil
				end

			else
				return nil
			end
		else
			return nil
		end
	end

	def self.getDescriptionFromApi(product_api_data)
		description = nil
		if product_api_data["name"].present?
			description = product_api_data["name"]
		elsif product_api_data["shortName"].present?
			description = product_api_data["shortName"]
		end
		return description
	end
	
end
