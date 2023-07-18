# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    new_user = User.new(user_params)

    if params[:user][:password] == params[:user][:password_confirmation] && new_user.save
      redirect_to user_path(new_user)
    elsif params[:user][:password] != params[:user][:password_confirmation]
      redirect_to register_path
      flash[:mismatch] = "Error: Passwords don't match"
    else
      redirect_to register_path
      flash[:alert] = "Error: #{error_message(new_user.errors)}"
    end
  end

  def show
    @user = User.find(params[:id])
    @movie_facade = MovieFacade.new(params[:id])
  end

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      flash[:error] = "Error: Credentials are incorrect"
      render :login_form
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
