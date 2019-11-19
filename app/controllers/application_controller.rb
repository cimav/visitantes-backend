class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  def auth_required
    redirect_to '/login' unless authenticated?
  end

  def authenticated?
    if session[:user_auth].blank?
      user = Usuario.where(:email => session[:user_email]).first
      session[:user_auth] = user && user.email == session[:user_email]
      if session[:user_auth]
        session[:user_id] = user.id
      end
    else
      session[:user_auth]
    end
  end

  helper_method :authenticated?
  helper_method :current_user
  helper_method :sede

  def current_user
    @current_user ||= Usuario.find(session[:user_id]) if session[:user_id]
  end

  def current_sede

  end

  SEDES = {
      1 => 'Chihuahua',
      2 => 'Cd. Juárez',
      3 => 'Monterrey',
      4 => 'Durango'
  }

  def sede
    SEDES[@current_user.sede] rescue 'Sin Sede'
  end

end
