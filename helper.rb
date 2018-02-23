require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'
require "socket"
require 'optparse'
require 'io/console'


class Source
  @count
  @size_array
  @ip=""
  @minute_eps_array
  @minute_size_array
  @hour_eps_array
  @hour_size_array
  @peak
  @peak_time

  @hour_average_eps
  @hour_average_size

  def initialize(ip)
    @ip=ip
    @count=0
    @size_array=[]
    @minute_eps_array=[]
    @minute_size_array=[]
    @hour_eps_array=[]
    @hour_size_array=[]
    @hour_average_eps=0
    @hour_average_size=0
    @peak=0
  end

  def ip
    @ip
  end

  def hit
    @count+=1
  end

  def size ns
    @size_array<<ns
  end

  def avg_size
    begin
      if @size_array.size==0
        a= 0
      else
        a=@size_array.inject(0.0) { |sum, el| sum + el } / @size_array.size
      end
      @size_array=[]
      @minute_size_array<<a if a!=0
      return a.round(1)
    end

  end

  def count
    a=@count
    @count=0
    @minute_eps_array<< a

    if a>@peak
      @peak=a
      @peak_time=Time.now
    end
    return a
  end


  def minute_average_size
    @minute_size_array=@minute_size_array.last(60)
    a=@minute_size_array.inject(0.0) { |sum, el| sum + el } / @minute_size_array.size
    a.round(1)
  end


  def minute_average_eps
    @minute_eps_array=@minute_eps_array.last(60)
    a=@minute_eps_array.inject(0.0) { |sum, el| sum + el } / @minute_eps_array.size
    a.round(1)
  end


  def show
    "#{@count} #{@size_array}"
  end

  def peak
    return @peak
  end

  def peak_time
    return @peak_time
  end

  def min_tick
    @hour_eps_array<<minute_average_eps
    @hour_eps_array=@hour_eps_array.last(60)
    @hour_average_eps= @hour_eps_array.inject(0.0) { |sum, el| sum + el } / @hour_eps_array.size

    @hour_size_array<<minute_average_size
    @hour_size_array=@hour_size_array.last(60)
    @hour_average_size= @hour_size_array.inject(0.0) { |sum, el| sum + el } / @hour_size_array.size
  end

  def hour_average_eps
    @hour_average_eps.round(1)
  end

  def hour_average_size
    @hour_average_size.round(1)
  end


end

def gem_install(lib)
  begin

    Gem::GemRunner.new.run ['install', "#{lib}.gem", "--local"] unless Gem::Specification.map { |g| g.name }.include?(lib)
  rescue Gem::SystemExitException => e
    p e
  end
end

gem_install "unicode-display_width"
gem_install "terminal-table"

require "terminal-table"


@options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: eps.rb [options]"

  opts.on('-p port', 'Listening port (default 514)') do |port|
    @options[:port] = port
  end

  opts.on('-i', 'IP mode (default ip and port)') do |ip|
    @options[:ip_mode] = ip
  end

  opts.on('-n', 'Dont save on exit') do |n_save|
    @options[:n_save] = n_save
  end

  opts.on('-t', 'TCP based (Default UDP)') do |tcp|
    @options[:tcp] = tcp
  end

  opts.on_tail('-v', "Show version") do
    puts "\nEps monitor 1.0\n\nhttps://www.linkedin.com/in/semsaksoy\n\n"
    exit
  end

end.parse!

@options[:port]=514 if @options[:port].nil?
@options[:ip_mode]=false if @options[:ip_mode].nil?
@options[:n_save]= false if @options[:n_save].nil?
@options[:tcp]= false if @options[:tcp].nil?



