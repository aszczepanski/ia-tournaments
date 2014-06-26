class StaticPagesController < ApplicationController
  def home
    if params[:search] 
      @tournaments = Tournament.name_like(params[:search])
        .paginate(page: params[:page], per_page: 10)
      if @tournaments.size.zero? 
        @tournaments = Tournament.all.paginate(page: params[:page], per_page: 10)
      end 
    else 
      @tournaments = Tournament.all.paginate(page: params[:page], per_page: 10)
    end 
  end

  def about
  end

  def contact
  end

  def help
  end
end
