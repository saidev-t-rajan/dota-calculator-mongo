class Scrapers
  attr_reader :errors

  def initialize(winrate, opts={})
    @start_time = Time.now
    @retry = opts[:retry] || 3
    @min = opts[:min] || 5
    @pool = opts[:pool] || 20

    @winrate = winrate
    @chinese_names = @winrate.heros.pluck(:name_ch)

    @semaphore = Mutex.new
    @que = Queue.new
    @failed_scrapes = Queue.new
    @errors = []
  end

  def scrape_and_build!
    @winrate.heros.each do |hero|
      @que << [hero, 'combo']
      @que << [hero, 'anti']
    end

    rtry = @retry
    until (rtry < 0 || @que.empty? || Time.now > (@start_time + @min.minutes))
      puts "=======================STARTING RETRY #{@retry - rtry}=======================" unless rtry == @retry
      threads = @pool.times.map do
                  Thread.new do
                    until @que.empty?
                      hero, arg = @que.shift
                      details = get_details_from_web(hero.send("url_#{arg}"))
                      if details
                        @semaphore.synchronize do
                          details.each do |name_ch, rate|
                            hero.with_heros.find_by(name_ch: name_ch).send("#{arg}=", rate.to_d)
                          end
                          hero.send("#{arg}_u_at=", Time.now)
                        end
                      else
                        @failed_scrapes << [hero, arg]
                      end
                    end
                  end
                end

      threads.each(&:join)

      until @failed_scrapes.empty?
        @que << @failed_scrapes.shift
      end
      rtry -= 1
    end

    return true if @que.empty?

    @errors << "Time Exeeded #{@min} minutes" if Time.now > (@start_time + 5.minutes)
    @errors << "Retry Exeeded #{@retry} times" if rtry < 0
    false
  end

  def get_details_from_web(url)
    puts "URL: #{url}"

    Nokogiri::HTML(open(url)).css("//table.table//tbody//tr").map do |row|
      name_ch = row.css("td")[0].text
      raise "Chinese name #{name_ch} does not exist" unless @chinese_names.include? name_ch

      [name_ch, row.css("td")[2].text]
    end

  rescue Exception => e
    puts "ERROR for #{url}: #{e.message}"
    puts "ERROR BACKTRACE: #{e.backtrace.inspect}"
    false
  end
end