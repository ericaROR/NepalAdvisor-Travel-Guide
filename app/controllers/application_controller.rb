class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout
  before_action :set_menu
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_location

  def store_location
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
      request.path != "/users/sign_up" &&
      request.path != "/users/password/new" &&
      request.path != "/users/password/edit" &&
      request.path != "/users/confirmation" &&
      request.path != "/users/sign_out" &&
      !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:password, :password_confirmation, :current_password) }
  end
  
  def layout
    if controller_name == "home_controller"
      layout 'home'
    end
  end

  def authenticate_active_admin_user!
    authenticate_user!
    if current_user.role?(:normal)
      flash[:alert] = "You are not authorized to access this resource!"
      redirect_to root_path
    end
  end

  private
  
  def set_menu
    @menus ||= Category.where(:is_menu => true).order(:Order)
    @footer_menus ||= Contact.where(:Home_page => true).order(:Order)
    @quicklinks ||= Contact.find_by_Slug("quick-links")
    @more ||= Contact.find_by_Slug("more")
    @restaurant ||= Category.find_by_slug("restaurants")
    @thingstodo ||= Category.find_by_slug("thingstodo")
    @vertical_advertisement ||= Advertisement.where(:position => "vertical").where("(started_date <= ? AND ended_date >= ?) OR (clicked <= max_clicked)", Date.today, Date.today).limit(3).order("RANDOM()")
    @horizontal_advertisement ||= Advertisement.where(:position => "horizontal").where("(started_date <= ? AND ended_date >= ?) OR (clicked <= max_clicked)", Date.today, Date.today).order("RANDOM()").limit(1)   
  end
end
