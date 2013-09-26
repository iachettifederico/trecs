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

  def create_frame(file_name: "", content: "", time: 0)
    File.open("#{project_dir}/#{time}_#{file_name}", File::WRONLY|File::CREAT) do |f|
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

        output = trecs("-f", file_name)

        output.read.should == "File #{file_name} does not exist.\n"
      end

      specify "reads a one frame screencast" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"


        create_frame(time: 0, file_name: file_basename, content: "FIRST FRAME")
        output = trecs("-f", file_name)

        output.read.should == "FIRST FRAME\n"

      end

      specify "returns the frame at certain time" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        create_frame(time: 0,   file_name: file_basename, content: "FIRST FRAME")
        create_frame(time: 100, file_name: file_basename, content: "FRAME AT 100")

        output = trecs("-f", file_name, "-t", 100)

        output.read.should == "FRAME AT 100\n"
      end
    end
  end
end
