require "spec_helper"
require "fileutils"

describe "T-Recs" do
  include FileUtils
  def create_dir(dir_path)
    rm_rf dir_path
    mkdir_p dir_path
    dir_path
  end

  context "trecs command" do
    let(:trecs_root)   { File.expand_path("../..", __FILE__) }
    let(:bin)          { "#{trecs_root}/bin"    }
    let(:temp_dir)     { create_dir("#{trecs_root}/tmp")    }
    let(:project_dir)  { create_dir("#{temp_dir}/project") }

    let(:exe)          { "#{bin}/trecs" }

    specify "is in place and executes" do
      expect { IO.popen(exe) }.not_to raise_exception
    end

    context "Player" do
      specify "returns an error whe project doesn't exist" do
        file_name = "path/to/a/non/existing/file.txt"

        command = []
        command << exe
        command << "-f"
        command << "#{file_name}"
        output = IO.popen(command)

        output.read.should == "File #{file_name} does not exist.\n"

      end

      specify "reads a one frame screencast" do
        file_basename = "file.txt"
        file_name = "#{project_dir}/#{file_basename}"

        File.open("#{project_dir}/0_#{file_basename}", File::WRONLY|File::CREAT) do |f|
          f << "0"
        end

        command = []
        command << exe
        command << "-f"
        command << "#{file_name}"
        output = IO.popen(command)

        output.read.should == "0\n"

      end
    end
  end
end
