require "spec_helper"
require "fileutils"
require 'zip'

describe "T-Recs" do
  include FileUtils

  define :have_frames do |expected|
    match do |actual|
      actual   = actual.split("\e[H\e[2J\n").select { |f|
        (/\S/ === f)
      }.map(&:chomp)
      expected = Array(expected)
      actual == expected
    end
  end

  let(:trecs_root)   { File.expand_path("../..", __FILE__) }
  let(:bin)          { "#{trecs_root}/bin" }
  let(:exe)          { "#{bin}/trecs_message" }
  let(:play_exe)     { "#{bin}/trecs" }

  let(:project_dir)  { create_dir("#{trecs_root}/tmp") }


  def trecs(*args, &block)
    command = [exe]
      .concat(args.map(&:to_s))
      .concat(["2>&1"])
      .join(" ")
    IO.popen(command) do |output|
      yield output.read if block_given?
    end
  end

  def play(*args, &block)
    command = [play_exe]
      .concat(args.map(&:to_s))
      .concat(["testing", "2>&1"])
      .join(" ")
    IO.popen(command) do |output|
      yield output.read if block_given?
    end
  end

  context "trecs_message command" do
    after do
      rm file_name if file_name
    end

    specify "is in place and executes" do
      expect { trecs }.not_to raise_exception
      trecs do |output|
        output.should_not match /error/i
      end
    end

    it "expects a file name" do
      trecs do |output|
        output.should have_frames "Please give a file name"
      end
    end

    it "generates a .trecs compressed file" do
      file_name "i_should_exist"
      trecs("-f", file_name, "--message", "a")

      File.exists?(file_name).should be_true
      expect { Zip::File.open(file_name) }.not_to raise_error(Zip::ZipError)
    end

    context "recording" do
      it "records a one letter message screencast" do
        file_name "a"

        trecs("-f", file_name, "--message", "a")

        play("-f", file_name) do |output|
          output.should have_frames "a"
        end
      end

      it "records a two letters message screencast" do
        file_name "ab"

        trecs("-f", file_name, "--message", "ab")

        play("-f", file_name) do |output|
          output.should have_frames ["a", "ab"]
        end
      end

      it "records a three letters message screencast" do
        file_name "abc"

        trecs("-f", file_name, "--message", "abc")

        play("-f", file_name) do |output|
          output.should have_frames ["a", "ab", "abc"]
        end
      end
    end

    context "timestamps" do
      it "uses 100 ms by default" do
        file_name "abcd"

        trecs("-f", file_name, "-m", "abcd")

        play("-f", file_name, "--timestamps") do |output|
          output.should have_frames "[0, 100, 200, 300]"
        end
      end

      it "accepts a step parameter" do
        file_name "abc"

        trecs("-f", file_name, "-m", "abcd", "-s", "250")

        play("-f", file_name, "--timestamps") do |output|
          output.should have_frames "[0, 250, 500, 750]"
        end
      end
    end
  end
end
