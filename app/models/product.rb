class Product
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :nombre, :sku, :img_url, :descripcion, :rend_caja, :precio

  validates_presence_of :nombre, :sku, :img_url, :descripcion, :rend_caja, :precio

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def sku=(new_sku)
    @sku = new_sku.strip
  end

  def nombre=(new_nombre)
    @nombre = new_nombre.strip
  end

  def img_url=(new_img_url)
    @img_url = new_img_url.strip
  end

  def descripcion=(new_descripcion)
    @descripcion = new_descripcion.strip if new_descripcion.present?
  end
end