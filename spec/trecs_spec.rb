require "spec_helper"
require 'pty'
require "fileutils"

describe "T-Recs" do
  include FileUtils

  let(:trecs_root)   { File.expand_path("../..", __FILE__) }
  let(:bin)          { "#{trecs_root}/bin"    }
  let(:exe)          { "#{bin}/trecs" }

  let(:temp_dir)     { create_dir("#{trecs_root}/tmp")    }
  let(:project_dir)  { create_dir("#{temp_dir}/project") }

  def create_dir(dir_path)
    rm_rf dir_path
    mkdir_p dir_path
    dir_path
  end

  def trecs(*args, &block)
    command = [exe].concat(args.map(&:to_s)).join(" ")
    PTY.spawn( command ) do |stdin, stdout, pid|
      begin
        stdin.each { |line| yield line.gsub(/\r\n\Z/, '') }
      rescue Errno::EIO
      end
    end
  rescue PTY::ChildExited
    puts "The child process exited!"
  end

  def create_frame(file_name: "", content: "", time: 0)
    File.open("#{project_dir}/#{time.to_i}_#{file_name}", File::WRONLY|File::CREAT) do |f|
      f << content
    end
  end

  context "trecs command" do
    specify "is in place and executes" do
      expect { trecs }.not_to raise_exception
    end

    context "Player" do
      specify "returns an error whe project doesn't exist" do
        file_name = "path/to/a/non/existing/file.txt"

        trecs("-f", file_name) do |output|
          output.should == "File #{file_name} does not exist."
        end
      end

      specify "reads a one frame screencast" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0, file_name: file_basename, content: "FIRST FRAME")
        trecs("-f", file_name) do |output|
          output.should == "FIRST FRAME"
        end
      end

      specify "returns the frame at certain time" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
        create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")

        trecs("-f", file_name, "-t", 100) do |output|
          output.should == "FRAME AT 100"
        end

      end

      specify "returns the previous frame if no frame at certain time" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
        create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")
        create_frame(time: 200, file_name: file_basename, content: "FRAME AT 200")

        trecs("-f", file_name, "-t", 111) do |output|
          output.should == "FRAME AT 100"
        end

      end
    end

    describe "Timestamps" do
      specify "returns all the frame timestamps" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
        create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")
        create_frame(time: 200, file_name: file_basename, content: "FRAME AT 200")

        trecs("-f", file_name, "--timestamps") do |output|
          output.should == "[0, 100, 200]"
        end

      end

    end
  end
end
