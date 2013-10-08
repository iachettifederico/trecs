#!/usr/bin/env ruby

require "./create_recording"
require "trollop"

def com(c)
  IO.popen(c).read
end

def cowsay(msg="")
  com "cowsay '#{msg}'"
end

def figlet(msg="")
  com "figlet '#{msg}'"
end


def map_increments(s='')
  0.upto(s.size-1).map do |i|
    s[0..i]
  end
end

options = Trollop::options do
  opt :file,    "File name", short: 'f', type: String
  opt :message, "Message",   short: 'm', type: String
  opt :step,    "step",      short: 's', type: String
  opt :cow
  opt :figlet
end

step = (options[:step] || 250).to_i

frames = map_increments(options[:message])

create_recording(file_name: options[:file]) do
  frames.each_with_index do |frame, i|
    frame = if options[:cow]
              cowsay(frame)
            elsif options[:figlet]
              figlet(frame)
            else
              frame
            end
    create_frame time: i*step, content: frame
  end
end

puts "Recorded to: #{options[:file]}"
