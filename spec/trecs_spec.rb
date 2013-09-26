require "spec_helper"
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

  def trecs(*args)
    command = [exe].concat(args.map(&:to_s))
    IO.popen(command)
  end


  context "trecs command" do
    specify "is in place and executes" do
      expect { trecs }.not_to raise_exception
    end

    context "Player" do
      specify "returns an error whe project doesn't exist" do
        file_name = "path/to/a/non/existing/file.txt"

        output = trecs("-f", file_name)

        output.read.should == "File #{file_name} does not exist.\n"
      end

      specify "reads a one frame screencast" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        File.open("#{project_dir}/0_#{file_basename}", File::WRONLY|File::CREAT) do |f|
          f << "FIRST FRAME"
        end
        output = trecs("-f", file_name)

        output.read.should == "FIRST FRAME\n"

      end

      specify "returns the frame at certain time" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        File.open("#{project_dir}/0_#{file_basename}", File::WRONLY|File::CREAT) do |f|
          f << "FIRST FRAME"
        end

        File.open("#{project_dir}/100_#{file_basename}", File::WRONLY|File::CREAT) do |f|
          f << "FRAME AT 100"
        end

        output = trecs("-f", file_name, "-t", 100)

        output.read.should == "FRAME AT 100\n"

      end

    end
  end
end
