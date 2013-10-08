require "spec_helper"
require "fileutils"
require 'zip'
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

  def create_recording(file_name: "")
    recording_dir = "#{File.dirname(file_name)}/frames"
    rm_rf recording_dir
    mkdir_p recording_dir
    rm file_name if File.exists? file_name

    yield recording_dir

    files_to_record = Dir.glob("#{recording_dir}/*")

    Zip::File.open(file_name, Zip::File::CREATE) do |trecs_file|
      files_to_record.each do |file_to_rec|
        dest_file_name = File.basename(file_to_rec)
        trecs_file.add(dest_file_name, file_to_rec)
      end
    end
    rm_rf Dir.glob("#{recording_dir}")
  end

  def create_frame(file_name: "", content: "", time: 0)
    File.open("#{project_dir}/frames/#{time.to_i}", File::WRONLY|File::CREAT) do |f|
      f << content
    end
  end

  context "trecs command" do
    specify "is in place and executes" do
      expect { trecs }.not_to raise_exception
    end

    context "Player" do
      specify "returns an error whe project doesn't exist" do
        non_existent = "path/to/a/non/existing/file.trecs"

        trecs("-f", non_existent) do |output|
          output.should have_frames "File #{non_existent} does not exist."
        end
      end

      specify "reads a one frame screencast" do
        file_basename = "one_frame.trecs"
        file_name = "#{project_dir}/#{file_basename}"

        create_recording(file_name: file_name) do
          create_frame(time: 0,  content: "FIRST FRAME")
        end

        trecs("-f", file_name) do |output|
          output.should have_frames "FIRST FRAME"
        end
      end

      specify "returns the frame at certain time" do
        file_basename = "two_frames.trecs"
        file_name = "#{project_dir}/#{file_basename}"

        create_recording(file_name: file_name) do
          create_frame(time: 0,   content: "FIRST FRAME")
          create_frame(time: 100, content: "FRAME AT 100")
        end

        trecs("-f", file_name, "-t", 100) do |output|
          output.should have_frames "FRAME AT 100"
        end

      end

      specify "returns the previous frame if no frame at certain time" do
        file_basename = "three_frames.trecs"
        file_name = "#{project_dir}/#{file_basename}"

        create_recording(file_name: file_name) do
          create_frame(time: 0,   content: "FIRST FRAME")
          create_frame(time: 100, content: "FRAME AT 100")
          create_frame(time: 200, content: "FRAME AT 200")
        end

        trecs("-f", file_name, "-t", 111) do |output|
          output.should have_frames "FRAME AT 100"
        end

      end

      specify "returns the last frame if asking for exceeding time" do
        file_basename = "three_frames.trecs"
        file_name = "#{project_dir}/#{file_basename}"

        create_recording(file_name: file_name) do
          create_frame(time: 0,   content: "FIRST FRAME")
          create_frame(time: 100, content: "FRAME AT 100")
          create_frame(time: 200, content: "FRAME AT 200")
        end

        trecs("-f", file_name, "-t", 201) do |output|
          output.should have_frames "FRAME AT 200"
        end

      end

      describe "multiple frame screencast" do
        specify "playing two frames" do
          file_basename = "two_frames.trecs"
          file_name     = "#{project_dir}/#{file_basename}"

          create_recording(file_name: file_name) do
            create_frame(time: 0,   content: "FIRST FRAME")
            create_frame(time: 100, content: "FRAME AT 100")
          end

          trecs("-f", file_name) do |output|
            output.should have_frames [
                              "FIRST FRAME",
                              "FRAME AT 100"
                             ]
          end
        end

        specify "playing all the frames frames" do
          file_basename = "three_frames.trecs"
          file_name     = "#{project_dir}/#{file_basename}"

          create_recording(file_name: file_name) do
            create_frame(time: 0,   content: "FIRST FRAME")
            create_frame(time: 100, content: "FRAME AT 100")
            create_frame(time: 200, content: "FRAME AT 200")
          end

          trecs("-f", file_name) do |output|
            output.should have_frames [
                                       "FIRST FRAME",
                                       "FRAME AT 100",
                                       "FRAME AT 200"
                                      ]
          end
        end

        specify "playing a recording" do
          file_basename = "multiple_frames.trecs"
          file_name     = "#{project_dir}/#{file_basename}"

          create_recording(file_name: file_name) do
            create_frame(time: 0,   content: "FIRST FRAME")
            create_frame(time: 100, content: "FRAME AT 100")
            create_frame(time: 200, content: "FRAME AT 200")
            create_frame(time: 301, content: "FRAME AT 301")
            create_frame(time: 499, content: "FRAME AT 499")
            create_frame(time: 599, content: "FRAME AT 599")
          end

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
        file_basename = "three_frames.trecs"
        file_name     = "#{project_dir}/#{file_basename}"

        create_recording(file_name: file_name) do
          create_frame(time: 0,   content: "FIRST FRAME")
          create_frame(time: 100, content: "FRAME AT 100")
          create_frame(time: 200, content: "FRAME AT 200")
        end

        trecs("-f", file_name, "--timestamps") do |output|
          output.should have_frames "[0, 100, 200]"
        end

      end

    end
  end
end
