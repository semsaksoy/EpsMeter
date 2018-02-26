#!/usr/bin/env ruby

require_relative "helper"


@stats=[]
@sources={}
@time=0
@report=""
@sender=nil
system "clear"

if !@options[:target_ip].nil? && !@options[:target_port].nil?
  @sender = UDPSocket.new
end


def min_tick
  @sources.keys.each do |k|
    @sources[k].min_tick
  end
end

def hour_tick

  @sources.keys.each do |k|
    @sources[k].hour_tick
  end
end


def tick
  begin
    rows = []
    @time+=1
    min_tick if @time%60==0
    hour_tick if @time%3600==0
    print "\r"+ ("\e[A\e[K"* (@sources.keys.count+9))


    rows<< [" Sources ", "  Live EPS/Size  ", " Peak EPS/Time ", " Avg(Minute) EPS / Size ", " Avg(Hour) EPS / Size ", " Avg(2 Days) EPS / Size "]
    rows << :separator


    @sources.keys.each do |k|
      rows<< ["#{@sources[k].ip}", "#{@sources[k].count} EPS/#{@sources[k].avg_size} Bytes",
              "#{@sources[k].peak} EPS/#{@sources[k].peak_time.strftime("%H:%M")}",
              "#{@sources[k].minute_average_eps} EPS/#{@sources[k].minute_average_size} Bytes",
              "#{@sources[k].hour_average_eps} EPS/#{@sources[k].hour_average_size} Bytes",
              "#{@sources[k].day_average_eps} EPS/#{@sources[k].day_average_size} Bytes"]

    end


    title="EPS Monitor  /  "
    title+="#{ @options[:ip_mode] ? "IP Mode" : "IP and Port Mode"}  /  "
    title+="Port: #{ @options[:tcp] ? "TCP" : "UDP"} #{@options[:port]}  /  "
    title+="Transport: #{@options[:target_ip]}:#{@options[:target_port]}  /  " unless @sender.nil?
    title+="#{Time.at(@time).utc.strftime("%H%H:%M:%S")}"


    table = Terminal::Table.new :rows => rows, :title => title
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


def listen_udp

  Socket.udp_server_loop(@options[:port]) do |msg, msg_src|

    if @options[:ip_mode]==false
      ip=msg_src.remote_address.inspect_sockaddr
    else
      ip=msg_src.remote_address.inspect_sockaddr.split(":").first
    end

    if @sources.keys.include?(ip)
      @sources[ip].hit
      @sources[ip].size msg.bytesize
    else
      @sources[ip]=Source.new(ip)
      @sources[ip].hit
      @sources[ip].size msg.bytesize
    end
    @sender.send(msg, 0, @options[:target_ip], @options[:target_port]) unless @sender.nil?

  end

end

def listen_tcp
  Socket.tcp_server_loop(@options[:port]) do |sock, msg_src|
    Thread.new do
      begin

        loop {
          m=sock.gets
          if !m.nil?

            if @options[:ip_mode]==false
              ip=msg_src.inspect_sockaddr
            else
              ip=msg_src.inspect_sockaddr.split(":").first
            end


            if @sources.keys.include?(ip)
              @sources[ip].hit
              @sources[ip].size m.bytesize
            else
              @sources[ip]=Source.new(ip)
              @sources[ip].hit
              @sources[ip].size m.bytesize
            end
          end


        }
      ensure
        sock.close
      end
    end
  end
end


begin
  if @options[:tcp]==true
    listen_tcp
  else
    listen_udp
  end


rescue Exception => e
  #@sender.close
  if @options[:n_save]==false
    f="Eps_#{Time.now.strftime("%m_%d_%Y_%H_%M_%S")}.txt"
    File.write(f, @report)
    print "\n\n#{f} saved."

  end
  p e.message
  print "\n\n"
end