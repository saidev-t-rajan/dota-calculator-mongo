require 'open-uri'


class Hero
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :winrate
  embeds_many :with_heros

  field :name,      type: String
  field :name_std,  type: Symbol
  field :name_ch,   type: String
  field :name_url,  type: String


  DOTAMAXURL = "http://dotamax.com/hero/detail"


  def update_from_web
    build_from_web :combo
    build_from_web :anti

    save
  end


  def build_from_web(arg)
    get_details_from_web(url arg).each do |name_ch, rate|
      with_heros.find_by(name_ch: name_ch).send(arg.to_s + '=', rate.to_d)
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
  end  
end