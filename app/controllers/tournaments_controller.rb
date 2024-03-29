class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update,
                                            :destroy, :organized, :participated,
                                            :new_join, :create_join,
                                            :new_sponsor, :create_sponsor, :show_sponsors]
  before_action :correct_user, only: [:edit, :update, :destroy,
                                      :new_sponsor, :create_sponsor, :show_sponsors]
  before_action :validate_new_join, only: :new_join
  before_action :validate_create_join, only: :create_join
  before_action :validate_modify_in_past, only: [:edit, :update]

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
    @hash = Gmaps4rails.build_markers(@tournament) do |tournament, marker|
      marker.lat tournament.latitude
      marker.lng tournament.longitude
      marker.infowindow tournament.name
    end
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
    @participation = @tournament.participations.new
  end

  def create_join
    @participation = current_user.participations.build(participation_params)
    if @participation.save
      flash[:success] = "Joined tournament."
      redirect_to @tournament
    else
      render 'new_join'
    end
  end

  def show_sponsors
    @tournament = Tournament.find(params[:id])
    @sponsors = @tournament.sponsors
  end

  def new_sponsor 
    @sponsor = @tournament.sponsors.new
  end

  def create_sponsor
    @sponsor = @tournament.sponsors.build(sponsor_params)
    if @sponsor.save
      flash[:success] = "Sponsor added."
      redirect_to show_sponsors_tournament_path
    else
      render 'new_sponsor'
    end
  end

  protected

    def tournament_params
      params.require(:tournament).permit(:name, :date, :deadline, :address,
                                :max_number_of_contestants, :seeding_number)
    end

    def participation_params
      params.require(:participation).permit(:tournament_id, :user_license_id, :user_rank_position)
    end

    def sponsor_params
      params.require(:sponsor).permit(:name, :logo)
    end

    def correct_user
      @tournament = current_user.tournaments.find_by(id: params[:id])
      redirect_to root_path if @tournament.nil?
    end

    def validate_new_join
      @tournament = Tournament.find(params[:id])
      can_be_joined
    end

    def validate_create_join
      @tournament = Tournament.find(participation_params[:tournament_id])
      can_be_joined
    end

    def validate_modify_in_past
      if @tournament.deadline.localtime < Time.zone.now
        flash[:error] = "You can't modify tournament after deadline."
        redirect_to @tournament
      end
    end

    def can_be_joined
      if !@tournament.joinable? || @tournament.is_contestant?(current_user)
        flash[:error] = "You can't join this tournament."
        redirect_to @tournament
      end
    end
end
