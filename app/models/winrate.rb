class Winrate
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :heros

  field :type,    type: String
  field :time,    type: String
  field :skill,   type: String
  field :filter,  type: String

  before_create :set_filter, :build_all_heros, :build_all_with_heros

  def update_from_web(opts={})
    if opts[:async] == false
      heros.map(&:update_from_web)
    else
      scrapers = Scrapers.new(self, opts)
      scrapers.scrape_and_build!
    end

    save
  end

  private

  def set_filter
    filter = '/'

    conditions = []
    conditions << "ladder=#{type}"  if type
    conditions << "time=#{time}"    if time
    conditions << "skill=#{skill}"  if skill

    if conditions.any?
      filter = "#{filter}?#{conditions.shift}"
      conditions.each do |condition|
        filter = "#{filter}&#{condition}"
      end
    end

    self.filter = filter
  end

  def build_all_with_heros
    heros.each(&:build_with_heros)
  end

  def build_all_heros
    heros_hash = {"Juggernaut"=>"主宰",
                  "Pudge"=>"帕吉",
                  "Spectre"=>"幽鬼",
                  "Ogre Magi"=>"食人魔魔法师",
                  "Wraith King"=>"冥魂大帝",
                  "Crystal Maiden"=>"水晶室女",
                  "Luna"=>"露娜",
                  "Legion Commander"=>"军团指挥官",
                  "Beastmaster"=>"兽王",
                  "Lifestealer"=>"噬魂鬼",
                  "Skywrath Mage"=>"天怒法师",
                  "Bounty Hunter"=>"赏金猎人",
                  "Silencer"=>"沉默术士",
                  "Slardar"=>"斯拉达",
                  "Axe"=>"斧王",
                  "Vengeful Spirit"=>"复仇之魂",
                  "Huskar"=>"哈斯卡",
                  "Shadow Shaman"=>"暗影萨满",
                  "Mirana"=>"米拉娜",
                  "Storm Spirit"=>"风暴之灵",
                  "Troll Warlord"=>"巨魔战将",
                  "Puck"=>"帕克",
                  "Shadow Fiend"=>"影魔",
                  "Earth Spirit"=>"大地之灵",
                  "Chen"=>"陈",
                  "Tidehunter"=>"潮汐猎人",
                  "Queen of Pain"=>"痛苦女王",
                  "Centaur Warrunner"=>"半人马战行者",
                  "Io"=>"艾欧",
                  "Venomancer"=>"剧毒术士",
                  "Spirit Breaker"=>"裂魂人",
                  "Batrider"=>"蝙蝠骑士",
                  "Clinkz"=>"克林克兹",
                  "Drow Ranger"=>"卓尔游侠",
                  "Zeus"=>"宙斯",
                  "Bloodseeker"=>"嗜血狂魔",
                  "Lone Druid"=>"德鲁伊",
                  "Phoenix"=>"凤凰",
                  "Night Stalker"=>"暗夜魔王",
                  "Techies"=>"工程师",
                  "Gyrocopter"=>"矮人直升机",
                  "Ember Spirit"=>"灰烬之灵",
                  "Morphling"=>"变体精灵",
                  "Disruptor"=>"干扰者",
                  "Chaos Knight"=>"混沌骑士",
                  "Templar Assassin"=>"圣堂刺客",
                  "Clockwerk"=>"发条技师",
                  "Lion"=>"莱恩",
                  "Necrophos"=>"瘟疫法师",
                  "Timbersaw"=>"伐木机",
                  "Death Prophet"=>"死亡先知",
                  "Phantom Assassin"=>"幻影刺客",
                  "Viper"=>"冥界亚龙",
                  "Witch Doctor"=>"巫医",
                  "Sven"=>"斯温",
                  "Pugna"=>"帕格纳",
                  "Dragon Knight"=>"龙骑士",
                  "Windranger"=>"风行者",
                  "Riki"=>"力丸",
                  "Alchemist"=>"炼金术士",
                  "Ursa"=>"熊战士",
                  "Earthshaker"=>"撼地者",
                  "Faceless Void"=>"虚空假面",
                  "Keeper of the Light"=>"光之守卫",
                  "Shadow Demon"=>"暗影恶魔",
                  "Sniper"=>"狙击手",
                  "Meepo"=>"米波",
                  "Nyx Assassin"=>"司夜刺客",
                  "Kunkka"=>"昆卡",
                  "Rubick"=>"拉比克",
                  "Enigma"=>"谜团",
                  "Brewmaster"=>"酒仙",
                  "Tinker"=>"修补匠",
                  "Doom"=>"末日使者",
                  "Terrorblade"=>"恐怖利刃",
                  "Invoker"=>"祈求者",
                  "Magnus"=>"马格纳斯",
                  "Bane"=>"祸乱之源",
                  "Tusk"=>"巨牙海民",
                  "Tiny"=>"小小",
                  "Lich"=>"巫妖",
                  "Bristleback"=>"钢背兽",
                  "Nature\'s Prophet"=>"先知",
                  "Slark"=>"斯拉克",
                  "Sand King"=>"沙王",
                  "Weaver"=>"编织者",
                  "Phantom Lancer"=>"幻影长矛手",
                  "Treant Protector"=>"树精卫士",
                  "Jakiro"=>"杰奇洛",
                  "Elder Titan"=>"上古巨神",
                  "Omniknight"=>"全能骑士",
                  "Lina"=>"莉娜",
                  "Lycan"=>"狼人",
                  "Enchantress"=>"魅惑魔女",
                  "Dazzle"=>"戴泽",
                  "Razor"=>"剃刀",
                  "Medusa"=>"美杜莎",
                  "Dark Seer"=>"黑暗贤者",
                  "Broodmother"=>"育母蜘蛛",
                  "Ancient Apparition"=>"远古冰魄",
                  "Leshrac"=>"拉席克",
                  "Warlock"=>"术士",
                  "Naga Siren"=>"娜迦海妖",
                  "Oracle"=>"神谕者",
                  "Anti-Mage"=>"敌法师",
                  "Visage"=>"维萨吉",
                  "Outworld Devourer"=>"殁境神蚀者",
                  "Undying"=>"不朽尸王",
                  "Abaddon "=>"亚巴顿",
                  "Winter Wyvern"=>"寒冬飞龙"}

    weird_heros_hash = {"Wraith King"=>"skeleton_king", 
                        "Lifestealer"=>"life_stealer", 
                        "Vengeful Spirit"=>"vengefulspirit", 
                        "Shadow Fiend"=>"nevermore", 
                        "Queen of Pain"=>"queenofpain", 
                        "Centaur Warrunner"=>"centaur", 
                        "Io"=>"wisp", "Zeus"=>"zuus", 
                        "Clockwerk"=>"rattletrap", 
                        "Necrophos"=>"necrolyte", 
                        "Timbersaw"=>"shredder", 
                        "Windranger"=>"windrunner", 
                        "Doom"=>"doom_bringer", 
                        "Magnus"=>"magnataur", 
                        "Nature\'s Prophet"=>"furion", 
                        "Treant Protector"=>"treant", 
                        "Outworld Devourer"=>"obsidian_destroyer"}


    heros_hash.sort.to_h.each do |english, chinese|
      name_standard = english.strip.downcase.tr(' ', '_').tr('-', '').tr("'", '')
      name_url =  weird_heros_hash[english] || name_standard
      heros.build(name: english.strip, name_std: name_standard.to_sym, name_ch: chinese.strip, name_url: name_url).set_urls
    end
  end
end
