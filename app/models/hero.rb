require 'open-uri'


class Hero
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  embedded_in :winrate
  embeds_many :with_heros

  field :name,      type: String
  field :name_std,  type: Symbol
  field :name_ch,   type: String
  field :name_url,  type: String
  field :combo_u_at, type: ActiveSupport::TimeWithZone
  field :anti_u_at, type: ActiveSupport::TimeWithZone

  DOTAMAXURL = "http://dotamax.com/hero/detail"


  def update_from_web
    build_from_web :combo
    build_from_web :anti

    save
  end

  def update_from_web_only(arg)
    if build_from_web arg
      save
    else
      false
    end
  end

  def build_from_web(arg)
    details = get_details_from_web(url arg)

    if details.any?
      details.each do |name_ch, rate|
        with_heros.find_by(name_ch: name_ch).send(arg.to_s + '=', rate.to_d)
      end
      send(arg.to_s + '_u_at=', Time.now)

      true
    else
      puts "ERROR: WithHero details from web were empty, HERO: #{name}, ARG: #{arg}"
      winrate.que << {hero: name_std, arg: arg}

      false
    end
  end

  def url(arg)
    u = case arg
        when :combo
          "#{DOTAMAXURL}/match_up_comb/"
        when :anti
          "#{DOTAMAXURL}/match_up_anti/"
        end

    u + name_url + winrate.filter
  end

  def get_details_from_web(url)
    puts "URL: #{url}"
    page = Nokogiri::HTML(open(url))

    page.css("//table.table//tbody//tr").inject({}) do |attributes, row|
      name_ch = row.css("td")[0].text
      win_rate = row.css("td")[2].text

      attributes[name_ch] = win_rate
      
      attributes
    end

  rescue Exception => e  
    puts "ERROR MESSAGE: #{e.message}"
    puts "ERROR BACKTRACE: #{e.backtrace.inspect}"
    {}
  end

  def build_with_heros
    winrate.heros.sort_by{|h| h.name}.each do |hero|
      with_heros.build(hero_id: hero.id, name_std: hero.name_std, name_ch: hero.name_ch) unless hero == self
    end
  end
end