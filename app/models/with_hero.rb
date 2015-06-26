class WithHero
  include Mongoid::Document

  embedded_in :hero

  field :hero_id,   type: BSON::ObjectId
  field :combo,     type: BigDecimal
  field :anti,      type: BigDecimal

  # Cached
  field :name_std,  type: Symbol
  field :name_ch,   type: String

  def h
    hero.winrate.heros.find hero_id
  end
end
