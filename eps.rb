#!/usr/bin/env ruby

require_relative "helper"


@stats=[]
@sources={}
@time=0
@report=""
system "clear"


def min_tick
  @sources.keys.each do |k|
    @sources[k].min_tick
  end
end


def tick
  begin
    rows = []
    @time+=1
    min_tick if @time%60==0
    print "\r"+ ("\e[A\e[K"* (@sources.keys.count+9))


    rows<< ["Sources", "Live EPS/Size", "Peak EPS/Time", " Avg(Minute) EPS / Size", " Avg(Hour) EPS / Size"]
    rows << :separator


    @sources.keys.each do |k|
      rows<< ["#{@sources[k].ip}", "#{@sources[k].count} EPS/#{@sources[k].avg_size} Bytes",
              "#{@sources[k].peak} EPS/#{@sources[k].peak_time.strftime("%H:%M")}",
              "#{@sources[k].minute_average_eps} EPS/#{@sources[k].minute_average_size} Bytes",
              "#{@sources[k].hour_average_eps} EPS/#{@sources[k].hour_average_size} Bytes"]

    end
    table = Terminal::Table.new :rows => rows, :title => "EPS Monitor  /  "\
    "#{ @options[:ip_mode] ? "IP Mode" : "IP and Port Mode"}  /  "\
    "Port: #{@options[:port]}  /  "\
    "#{Time.at(@time).utc.strftime("%H:%M:%S")}"
    @report=table
    print table
  rescue Exception => e
    puts e.message
  end
end


t1=Thread.new do
  loop do
    sleep(1)
    tick
  end
end


def listen

  Socket.udp_server_loop(@options[:port]) do |msg, msg_src|

    if @options[:ip_mode]==false
      ip=msg_src.remote_address.inspect_sockaddr
    else
      ip=msg_src.remote_address.inspect_sockaddr.split(":").first
    end

    if @sources.keys.include?(ip)
      # p ip
      # p @sources[ip].ip

      @sources[ip].hit
      @sources[ip].size msg.bytesize


    else
      @sources[ip]=Source.new(ip)


      @sources[ip].hit
      @sources[ip].size msg.bytesize
    end


  end

end

begin
  listen

rescue Exception => e
  if @options[:n_save]==false
    f="Eps_#{Time.now.strftime("%m_%d_%Y_%H_%M_%S")}.txt"
    File.write(f, @report)
    print "\n\n#{f} saved."
  end
  print "\n\n"
end