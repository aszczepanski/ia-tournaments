class SponsorsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @sponsor = Sponsor.find(params[:id])
    @tournament = @sponsor.tournament
    if @tournament.organizer_id != current_user.id
      redirect_to root_path
    else
      @sponsor.destroy
      flash[:success] = "Sponsor deleted."
      redirect_to @tournament
    end
  end
end
