class SessionsController < ApplicationController

  def create

    if auth_hash[:info][:email] # Google
      session[:user_email] = auth_hash[:info][:email]
    else
      session[:user_email] = auth_hash[:extra][:id_info][:email]
    end

    if authenticated?
      redirect_to '/'
    else
      render :plain => '401 Sin autorizaciǿn', :status => 401
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end

  def failure
    render :plain => '403 Método de autorización fallido', :status => 403
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end

end
