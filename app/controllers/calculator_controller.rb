class CalculatorController < ApplicationController

  def index
    @heros = Winrate.first.heros.pluck(:name, :_id).to_h

    @radiant_win_percentage = session[:radiant_win_percentage]
    @dire_win_percentage = session[:dire_win_percentage]

    @winrate = session[:winrate]
    @radiant_1 = session[:radiant_1]
    @radiant_2 = session[:radiant_2]
    @radiant_3 = session[:radiant_3]
    @radiant_4 = session[:radiant_4]
    @radiant_5 = session[:radiant_5]
    @dire_1 = session[:dire_1]
    @dire_2 = session[:dire_2]
    @dire_3 = session[:dire_3]
    @dire_4 = session[:dire_4]
    @dire_5 = session[:dire_5]

    session[:radiant_win_percentage] = nil
    session[:dire_win_percentage] = nil

    session[:winrate] = nil
    session[:radiant_1] = nil
    session[:radiant_2] = nil
    session[:radiant_3] = nil
    session[:radiant_4] = nil
    session[:radiant_5] = nil
    session[:dire_1] = nil
    session[:dire_2] = nil
    session[:dire_3] = nil
    session[:dire_4] = nil
    session[:dire_5] = nil
  end

  def calculate
    draft = Draft.new(params[:draft])
    session[:radiant_win_percentage] = draft.radiant_win_percentage.round(2)
    session[:dire_win_percentage] = draft.dire_win_percentage.round(2)

    session[:radiant]

    session[:winrate] = params[:draft][:winrate]
    session[:radiant_1] = params[:draft][:radiant_1]
    session[:radiant_2] = params[:draft][:radiant_2]
    session[:radiant_3] = params[:draft][:radiant_3]
    session[:radiant_4] = params[:draft][:radiant_4]
    session[:radiant_5] = params[:draft][:radiant_5]
    session[:dire_1] = params[:draft][:dire_1]
    session[:dire_2] = params[:draft][:dire_2]
    session[:dire_3] = params[:draft][:dire_3]
    session[:dire_4] = params[:draft][:dire_4]
    session[:dire_5] = params[:draft][:dire_5]

    redirect_to root_path
  end
end