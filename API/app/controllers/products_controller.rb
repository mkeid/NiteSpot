class ProductsController < ApplicationController

  # The following creates a product.
  def create
    signed_in?
    product = Product.new
    product.cost = params[:product][:cost]
    product.label = params[:product][:label]
    product.name = params[:product][:name]
    product.save
    @service_self.products << product
  end

  # The following creates a list of the services products
  def list
    signed_in?
    render :template => "services/products/#{@service_self.id}"
  end

  # The following destroys a product if it belongs to the service.
  def destroy
    signed_in?
    if Product.exists?(params[:id]) && Product.find(prams[:id]).service == @service_self
      Product.find(params[:id]).destroy
    end
  end

end
