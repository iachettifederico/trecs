require "spec_helper"
require "fileutils"


describe "T-Recs" do
  include FileUtils
  def let_dir(dir_path)
    mkdir_p dir_path
    dir_path
  end

  context "trecs command" do
    let(:trecs_root)   { File.expand_path("../..", __FILE__) }
    let(:bin)          { let_dir("#{trecs_root}/bin")    }
    let(:temp_dir)     { let_dir("#{trecs_root}/tmp")    }
    let(:project_dir)  { let_dir("#{temp_dir}/project") }

    let(:exe)          { "#{bin}/trecs" }

    specify "is in place and executes" do
      expect { IO.popen(exe) }.not_to raise_exception
    end

    context "Player" do
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
