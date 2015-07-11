class WinratesController < ApplicationController
  before_action :set_winrate, only: [:show, :destroy]

  def index
    @winrates = Winrate.all
  end

  def new
    @winrate = Winrate.new
  end

  def create
    @winrate = Winrate.new(winrate_params)

    if @winrate.save
      flash[:success] = 'Winrate was successfully created.'
      redirect_to winrates_url
    else
      render :new
    end
  end

  def show
  end

  def destroy
    @winrate.destroy
    flash[:success] = "Winrate destroyed."
    redirect_to winrates_url
  end


  private

    def set_winrate
      @winrate = Winrate.find(params[:id])
    end

    def winrate_params
      params.require(:winrate).permit(:type, :time, :skill)
    end
end