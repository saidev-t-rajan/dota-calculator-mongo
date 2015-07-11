class WithHero
  include Mongoid::Document

  embedded_in :hero

  field :_id,       type: Symbol, overwrite: true
  field :combo,     type: BigDecimal
  field :anti,      type: BigDecimal

  # Cached
  field :name_ch,   type: String

  index(name_ch: 1)


  def h
    hero.winrate.heros.find(_id)
  end
end