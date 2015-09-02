class WinratesController < ApplicationController
  before_action :set_winrate, only: [:combo_csv, :anti_csv, :destroy]

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

  def destroy
    @winrate.destroy
    flash[:success] = "Winrate destroyed."
    redirect_to winrates_url
  end

  def combo_csv
    respond_to do |format|
      format.html { redirect_to root_path }
      format.csv { send_data @winrate.as_csv(:combo), filename: "#{@winrate._id}-combo.csv" }
    end
  end

  def anti_csv
    respond_to do |format|
      format.html { redirect_to root_path }
      format.csv { send_data @winrate.as_csv(:anti), filename: "#{@winrate._id}-anti.csv" }
    end
  end


  private

    def set_winrate
      @winrate = Winrate.find(params[:id])
    end

    def winrate_params
      params.require(:winrate).permit(:type, :time, :skill)
    end
end