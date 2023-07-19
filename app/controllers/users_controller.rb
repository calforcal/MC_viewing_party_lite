# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    new_user = User.new(user_params)

    if params[:user][:password] == params[:user][:password_confirmation] && new_user.save
      session[:user_id] = new_user.id
      flash[:success] = "Welcome, #{new_user.name}!"
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
