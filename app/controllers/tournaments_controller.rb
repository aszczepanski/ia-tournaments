class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @tournament = current_user.tournaments.new
  end

  def create
    @tournament = current_user.tournaments.build(tournament_params)
    if @tournament.save
      flash[:success] = "New tournament created."
      redirect_to @tournament
    else
      render 'new'
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  protected

    def tournament_params
      params.require(:tournament).permit(:name, :date, :deadline)
    end
end
