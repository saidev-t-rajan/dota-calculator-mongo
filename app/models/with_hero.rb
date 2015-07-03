class WithHero
  include Mongoid::Document

  embedded_in :hero

  field :_id,       type: Symbol
  field :combo,     type: BigDecimal
  field :anti,      type: BigDecimal

  # Cached
  field :name_ch,   type: String

  def h
    hero.winrate.heros.find_by(name_std: _id)
  end
end
