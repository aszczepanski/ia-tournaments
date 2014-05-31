class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show, :update]
  before_action :user_didnt_answer, only: :update
  before_action :is_ready, only: :update

  def index
    ids = []
    current_user.participated_tournaments.each do |t|
      match = t.user_next_match(current_user)
      ids.append match.id if match
    end
    @matches = Match.all.where(id: ids).paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def update
    if @match.add_winner(current_user, params[:winner]) == true
      flash[:success] = "You have successfully added the winner"
    else
      flash[:error] = "Error - try once again."
    end
    redirect_to matches_path
  end

  protected

    def correct_user
      @match = Match.find(params[:id])
      if @left_participation = current_user.participations.find_by(id: @match.left_user_id)
        return @left_participation
      elsif @right_participation = current_user.participations.find_by(id: @match.right_user_id)
        return @right_participation
      else
        redirect_to matches_path if @tournament.nil?
      end
    end

    def user_didnt_answer
      if @match.user_added_winner?(current_user)
        flash[:error] = "You have already added a winner"
        redirect_to matches_path
      end
    end

    def is_ready
      if !@match.is_ready?
        flash[:error] = "You can't add a winner for now."
        redirect_to matches_path
      end
    end
end
