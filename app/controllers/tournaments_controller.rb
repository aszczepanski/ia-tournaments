class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

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

  def edit
  end

  def update
    if @tournament.update_attributes(tournament_params)
      flash[:success] = "Tournament updated"
      redirect_to @tournament
    else
      render 'edit'
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def destroy
    @tournament.destroy
    redirect_to root_path
  end

  protected

    def tournament_params
      params.require(:tournament).permit(:name, :date, :deadline)
    end

    def correct_user
      @tournament = current_user.tournaments.find_by(id: params[:id])
      redirect_to root_path if @tournament.nil?
    end
end
