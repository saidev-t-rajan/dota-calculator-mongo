require 'open-uri'


class Hero
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  embedded_in :winrate
  embeds_many :with_heros

  field :name,        type: String
  field :name_std,    type: Symbol
  field :name_ch,     type: String
  field :name_url,    type: String
  field :url_anti,    type: String
  field :url_combo,   type: String
  field :combo_u_at,  type: ActiveSupport::TimeWithZone
  field :anti_u_at,   type: ActiveSupport::TimeWithZone


  DOTAMAXURL = "http://dotamax.com/hero/detail"


  def build_from_web(arg, details)
    details.each do |name_ch, rate|
      with_heros.find_by(name_ch: name_ch).send(arg.to_s + '=', rate.to_d)
    end
    send(arg.to_s + '_u_at=', Time.now)
  end

  def url(arg)
    u = case arg
        when :combo
          "#{DOTAMAXURL}/match_up_comb/"
        when :anti
          "#{DOTAMAXURL}/match_up_anti/"
        end

    u << name_url << winrate.filter
  end

  def build_with_heros
    winrate.heros.sort_by{|h| h.name}.each do |hero|
      with_heros.build(_id: hero.name_std, name_ch: hero.name_ch) unless hero == self
    end
  end

  def set_urls
    self.url_combo = url :combo
    self.url_anti = url :anti
  end
end