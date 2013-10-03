require "spec_helper"
require 'pty'
require "fileutils"
require 'rspec/expectations'

RSpec::Matchers.define :have_frames do |expected|
  match do |actual|
    actual   = actual.split("\e[H\e[2J\n").select{|f| (/\S/ === f)}.map(&:chomp)
    expected = Array(expected)
    actual == expected
  end
end

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
    command = [exe].concat(args.map(&:to_s)).concat(["--testing"]).join(" ")
    IO.popen(command) do |output|
      yield output.read if block_given?
    end
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
          output.should have_frames "File #{file_name} does not exist."
        end
      end

      specify "reads a one frame screencast" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0, file_name: file_basename, content: "FIRST FRAME")
        trecs("-f", file_name) do |output|
          output.should have_frames "FIRST FRAME"
        end
      end

      specify "returns the frame at certain time" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
        create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")

        trecs("-f", file_name, "-t", 100) do |output|
          output.should have_frames "FRAME AT 100"
        end

      end

      specify "returns the previous frame if no frame at certain time" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
        create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")
        create_frame(time: 200, file_name: file_basename, content: "FRAME AT 200")

        trecs("-f", file_name, "-t", 111) do |output|
          output.should have_frames "FRAME AT 100"
        end

      end

      specify "returns the last frame if asking for exceeding time" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
        create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")
        create_frame(time: 200, file_name: file_basename, content: "FRAME AT 200")

        trecs("-f", file_name, "-t", 201) do |output|
          output.should have_frames "FRAME AT 200"
        end

      end

      describe "multiple frame screencast" do
        let(:file_basename) { "file.txt" }
        let(:file_name) { "#{project_dir}/#{file_basename}" }

        specify "playing two frames" do
          create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
          create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")
          trecs("-f", file_name) do |output|
            output.should have_frames [
                              "FIRST FRAME",
                              "FRAME AT 100"
                             ]
          end
        end

        specify "playing all the frames frames" do
          create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
          create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")
          create_frame(time: 200, file_name: file_basename, content: "FRAME AT 200")
          trecs("-f", file_name) do |output|
            output.should have_frames [
                                       "FIRST FRAME",
                                       "FRAME AT 100",
                                       "FRAME AT 200"
                                      ]
          end
        end

        specify "playing a recording" do
          create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
          create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")
          create_frame(time: 200, file_name: file_basename, content: "FRAME AT 200")
          create_frame(time: 301, file_name: file_basename, content: "FRAME AT 301")
          create_frame(time: 499, file_name: file_basename, content: "FRAME AT 499")
          create_frame(time: 599, file_name: file_basename, content: "FRAME AT 599")
          trecs("-f", file_name) do |output|
            output.should have_frames [
                                       "FIRST FRAME",
                                       "FRAME AT 100",
                                       "FRAME AT 200",
                                       "FRAME AT 200",
                                       "FRAME AT 301",
                                       "FRAME AT 499",
                                       "FRAME AT 599",
                                     ]
          end
        end
      end
    end

    describe "Timestamps" do
      specify "returns all the frame timestamps" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
        create_frame(time: 200, file_name: file_basename, content: "FRAME AT 200")
        create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")

        trecs("-f", file_name, "--timestamps") do |output|
          output.should have_frames "[0, 100, 200]"
        end

      end

    end
  end
end
