class Draft

  attr_reader :radiant_win_percentage, :dire_win_percentage

  K = 0.551247203300392

  def initialize(params={})
    winrate = Winrate.find(params[:winrate])

    radiant_1 = winrate.heros.where(_id: params[:radiant_1]).first
    radiant_2 = winrate.heros.where(_id: params[:radiant_2]).first
    radiant_3 = winrate.heros.where(_id: params[:radiant_3]).first
    radiant_4 = winrate.heros.where(_id: params[:radiant_4]).first
    radiant_5 = winrate.heros.where(_id: params[:radiant_5]).first

    dire_1 = winrate.heros.where(_id: params[:dire_1]).first
    dire_2 = winrate.heros.where(_id: params[:dire_2]).first
    dire_3 = winrate.heros.where(_id: params[:dire_3]).first
    dire_4 = winrate.heros.where(_id: params[:dire_4]).first
    dire_5 = winrate.heros.where(_id: params[:dire_5]).first

    @radiant = [radiant_1, radiant_2, radiant_3, radiant_4, radiant_5].compact
    @dire = [dire_1, dire_2, dire_3, dire_4, dire_5].compact

    calculate
  end

  def calculate
    radiant_winrates = []
    dire_winrates = []

    @radiant.each do |hero|
      winrates_with_allies = @radiant.map { |ally_hero| hero.combo(ally_hero) }
      winrates_against_enemies = @dire.map { |enemy_hero| hero.anti(enemy_hero) }

      radiant_winrates << [winrates_with_allies.avg(4), winrates_against_enemies.avg(5)].avg
    end

    @dire.each do |hero|
      winrates_with_allies = @dire.map { |ally_hero| hero.combo(ally_hero) }
      winrates_against_enemies = @radiant.map { |enemy_hero| hero.anti(enemy_hero) }

      dire_winrates << [winrates_with_allies.avg(4), winrates_against_enemies.avg(5)].avg
    end

    radiant_winrate = radiant_winrates.avg(5) / 100
    dire_winrate = dire_winrates.avg(5) / 100

    @radiant_win_percentage = (((-radiant_winrate**K/Math.log(radiant_winrate))/(-radiant_winrate**K/Math.log(radiant_winrate)-dire_winrate**K/Math.log(dire_winrate))-0.5)*5.3 + 0.5) * 100

    @dire_win_percentage = 100 - radiant_win_percentage
  end
end