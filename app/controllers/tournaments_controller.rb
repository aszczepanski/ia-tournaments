class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update,
                                            :destroy, :organized, :participated,
                                            :new_join, :create_join]
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

  def organized
    @tournaments = current_user.tournaments.paginate(page: params[:page], per_page: 10)
  end

  def participated
    @tournaments = current_user.participated_tournaments.paginate(page: params[:page], per_page: 10)
  end

  def new_join
    @tournament = Tournament.find(params[:id])
    @participation = @tournament.participations.new
  end

  def create_join
    @tournament = Tournament.find(participation_params[:tournament_id])
    @participation = current_user.participations.build(participation_params)
    if @participation.save
      flash[:success] = "Joined tournament."
      redirect_to @tournament
    else
      render 'new_join'
    end
  end

  protected

    def tournament_params
      params.require(:tournament).permit(:name, :date, :deadline,
                                :max_number_of_contestants, :seeding_number)
    end

    def participation_params
      params.require(:participation).permit(:tournament_id, :user_license_id, :user_rank_position)
    end

    def correct_user
      @tournament = current_user.tournaments.find_by(id: params[:id])
      redirect_to root_path if @tournament.nil?
    end
end
