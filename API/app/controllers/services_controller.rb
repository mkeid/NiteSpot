class ServicesController < ApplicationController
  def index
  end

  # The following creates a new (food) service account.
  def create
    email = params[:service][:email].downcase
    password = params[:service][:password]
    if password != nil && password.length > 6  && !email.match('.edu')
    end
  end

  # The following displays a list of all the services belonging self_user's school.
  def list
    user_signed_in?
    render :json => @user_self.school.services.map { |service| {  :id => service.id,
                                                                  :avatar_location => service.avatar.url(),
                                                                  :label => service.label,
                                                                  :name => service.name,
                                                                  :phone_number => service.phone_number } }
  end

  # The following displays a single service.
  def show
    signed_in?
    service = Service.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        render :json => {:id => service.id,
                         :avatar_location => service.avatar.url('full'),
                         :label => service.id,
                         :name => service.name,
                         :phone_number => service.phone_number }
      end
    end
  end

  # The following updates a service account.
  def update
    service_signed_in?
  end

  def favorite
    user_signed_in?
    @user_self.favorite_services << Service.find(params[:id])
  end

  def unfavorite
    user_signed_in?
    UserFavorite.find_by_service_id_and_user_id(params[:id], @user_self.id).destroy
  end

  # This lists the orders of a service (only viewable by the service)
  def orders
    signed_in?
    service = Service.find(params[:id])
    if service == @service_self
      respond_to do |format|
        format.html
        format.json do
          render :json => service.orders.map { |order| { :id => order.id,
                                                         :cost => render_cost(order),
                                                         :user_name => render_name(order.user),
                                                         :service_id=> order.service_id,
                                                         :user_id => order.user_id }}
        end
      end
    end
  end

  # The following makes a purchase from a service.
  def purchase
    user_signed_in?
    service = Service.find(params[:id])
    require 'wepay'

    # credentials
    client_id = ''
    client_secret = ''
    access_token = 'STAGE_c713530e2d5ce4abd0c28a99ffbaf9e2f17798c8b3bffc06d55527f66b3ee79c'

    wepay = WepayCheckoutRecord.new
    wepay.client_id = client_id
    wepay.client_secret = client_secret
    response = wepay.call('/checkout/create', access_token, {
        :account_id => @user_self.id,
        :short_description => 'A ns test',
        :long_description => "#{render_name(@user_self)} paid COSTBEFORENSFEE to purchase food from #{render_name(service)}",
        :payer_email => @user_self.email,
        :payer_name => render_name(@user_self),
        :require_shipping => false,
        :type => 'Service',
        :amount => '4.95'
    })
    render :text => "#{response.checkout_uri}"
    #wepay = WePay.new('100321', 'ae618cbc91', true)
  end

  # The following lists all the products of a service.
  def products
    signed_in?
    @service = Service.find(params[:id])
    if @service.schools.include? @user_self.school || @service == @service_self
      respond_to do |format|
        format.html
        format.json do
          render :json => @service.products.map { |product| { :id => product.id,
                                                             :cost => product.cost,
                                                             :label => product.label,
                                                             :name => product.name,
                                                             :service_id => product.service_id }}
        end
      end
    end
  end

end
