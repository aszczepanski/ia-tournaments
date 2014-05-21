class StaticPagesController < ApplicationController
  def home
    @tournaments = Tournament.all.paginate(page: params[:page], per_page: 10)
  end

  def about
  end

  def contact
  end

  def help
  end
end
