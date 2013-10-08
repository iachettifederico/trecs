require "fileutils"
require 'zip'

include FileUtils
def create_recording(file_name: "")
  rm file_name if File.exists? file_name
  recording_dir = "./frames"
  rm_rf recording_dir
  mkdir_p recording_dir

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

def create_frame(content: "", time: 0)
  File.open("./frames/#{time.to_i}", File::WRONLY|File::CREAT) do |f|
    f << content
  end
end
