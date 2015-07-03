class Scrapers

  def initialize(winrate, opts={})
    @start_time = Time.now
    @retry = opts[:retry] || 3
    @min = opts[:min] || 5

    @winrate = winrate
    @chinese_names = @winrate.heros.pluck(:name_ch)

    @semaphore = Mutex.new
    @que = Queue.new
  end

  def scrape_and_build!
    @winrate.heros.each do |hero| 
      @que << { name: hero.name_std, arg: :combo, url: hero.url_combo }
      @que << { name: hero.name_std, arg: :anti, url: hero.url_anti }
    end

    rtry = @retry
    until rtry < 0 || @que.empty? || Time.now > (@start_time + 5.minutes)
      puts "=======================STARTING RETRY #{@retry - rtry}=======================" unless rtry == @retry
      threads = to_scrape.map do |hero|
                  Thread.new do
                    details = get_details_from_web hero[:url]
                    if details
                      @semaphore.synchronize do
                        @winrate.heros.find_by(name_std: hero[:name]).build_from_web hero[:arg], details
                      end
                    else
                      @que << hero
                    end
                  end
                end

      threads.each(&:join)
      rtry -= 1
    end
  end

  def name_ch_valid!(name)
    raise "Chinese name #{name} does not exist" unless @semaphore.synchronize{ @chinese_names.include? name }
    name
  end

  def get_details_from_web(url)
    puts "URL: #{url}"
    page = Nokogiri::HTML(open(url))

    page.css("//table.table//tbody//tr").inject({}) do |attributes, row|
      name_ch = row.css("td")[0].text
      raise "Chinese name #{name_ch} does not exist" unless @semaphore.synchronize{ @chinese_names.include? name_ch }

      win_rate = row.css("td")[2].text

      attributes[name_ch] = win_rate
      
      attributes
    end

  rescue Exception => e
    puts "ERROR MESSAGE: #{e.message}"
    puts "ERROR BACKTRACE: #{e.backtrace.inspect}"
    false
  end

  def to_scrape
    arr = []
    until @que.empty?
      arr << @que.shift
    end

    arr
  end
end