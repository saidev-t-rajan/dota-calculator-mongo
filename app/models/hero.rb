require 'open-uri'


class Hero
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  embedded_in :winrate
  embeds_many :with_heros

  field :_id,         type: Symbol
  field :name,        type: String
  field :name_ch,     type: String
  field :name_url,    type: String
  field :url_anti,    type: String
  field :url_combo,   type: String
  field :combo_u_at,  type: ActiveSupport::TimeWithZone
  field :anti_u_at,   type: ActiveSupport::TimeWithZone


  DOTAMAXURL = "http://dotamax.com/hero/detail"

  def combo(hero)
    with_heros.where(_id: hero._id).first.try(:combo)
  end

  def anti(hero)
    with_heros.where(_id: hero._id).first.try(:anti)
  end

  def build_from_web(arg, details)
    details.each do |name_ch, rate|
      with_heros.find_by(name_ch: name_ch).send("#{arg}=", rate.to_d)
    end
    send("#{arg}_u_at=", Time.now)
  end

  def set_urls
    self.url_combo  = "#{DOTAMAXURL}/match_up_comb/#{name_url}#{winrate.filter}"
    self.url_anti   = "#{DOTAMAXURL}/match_up_anti/#{name_url}#{winrate.filter}"
  end

  def build_with_heros
    winrate.heros.each do |hero|
      with_heros.build(_id: hero._id, name_ch: hero.name_ch) unless hero == self
    end
  end
end