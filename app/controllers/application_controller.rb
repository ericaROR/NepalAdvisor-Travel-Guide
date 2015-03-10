class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout
  before_filter :set_menu
  before_filter :configure_permitted_parameters, if: :devise_controller?
after_filter :store_location

def store_location
  # store last url - this is needed for post-login redirect to whatever the user last visited.
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


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
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
  # def current_user
  # 	@current_user ||= User.find_by_token!(cookies[:token]) if cookies[:token]
  # end
  # helper_method :current_user
  # def authorize
  # 	redirect_to log_in_url, alert: :"Not Authorized" if current_user.nil?
  # end
   def set_menu
        @menus ||= Category.where(:is_menu => true).order(:Order)
        @footer_menus ||= Contact.where(:Home_page => true).order(:Order)
        @quicklinks ||= Contact.find_by_Slug("quick-links")
        @restaurant ||= Category.find_by_slug("restaurants")
        @thingstodo ||= Category.find_by_slug("thingstodo")
        @vertical_advertisement ||= Advertisement.where(:position => "vertical").where("started_date <= ? AND ended_date >= ?", Date.today, Date.today).limit(3).order("RANDOM()")
        @horizontal_advertisement ||= Advertisement.where(:position => "horizontal").where("started_date <= ? AND ended_date >= ?", Date.today, Date.today).limit(1).order("RANDOM()")
        # @current_user ||= session[:user_id] 
       

       # @categories ||= Category.all
   end


# If your model is called User
def after_sign_in_path_for(resource)
  session["user_return_to"] || root_path
end

# Or if you need to blacklist for some reason
# def after_sign_in_path_for(resource)
#   blacklist = [new_user_session_path, new_user_registration_path, user_path(current_user.id)] # etc...
#   last_url = session["user_return_to"]

#   if blacklist.include?(last_url)
#     root_path
#   else
#     last_url
#   end
# end
end
