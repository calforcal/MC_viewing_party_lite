# frozen_string_literal: true

class ViewingPartiesController < ApplicationController
  before_action :find_user

  def new
    @movie_facade = MovieFacade.new(params[:movie_id])
    @users = User.excluding(@user)
    if !session[:user_id]
      redirect_to movie_path(params[:movie_id])
      flash[:invalid] = 'Must be registered and logged in to create a Viewing Party'
    end
  end

  def create
    if session[:user_id]
      viewing_party = ViewingParty.create!(viewing_party_params)
      # refactor this to move to model or facade?
      params[:user_ids].each do |id|
        UserParty.create!(
          user_id: id,
          viewing_party_id: viewing_party.id
        )
      end
      redirect_to dashboard_path(@user)
    else
      flash[:invalid] = 'Must be registered and logged in to create a Viewing Party'
    end
  end

  private

  def find_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = nil
    end
  end

  def viewing_party_params
    params.permit(
      :duration,
      :start_date,
      :start_time,
      :movie_id,
      :host_id
    )
  end
end
