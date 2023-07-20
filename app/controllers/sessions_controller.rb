class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to dashboard_path(user)
    else
      flash[:error] = "Error: Credentials are incorrect"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to '/'
  end
end