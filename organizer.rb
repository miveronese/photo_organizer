require 'exifr/jpeg'
require 'fileutils'
require 'date'
require 'time'

def organize_pics(st)
  path = st
  no_exif_data = []

  Dir.glob(path+'/*.*').each do |f|
    begin 
      if EXIFR::JPEG.new(f).exif?
        date = EXIFR::JPEG.new(f).date_time
        year = date.strftime('%Y')
        month = date.strftime('%B')
        x = FileUtils.mkdir_p(path+'/'+year+'/'+month)
        FileUtils.mv(f, x[0])     
      end
    rescue => e
      no_exif_data << f
      # puts "errs for #{f}: #{e.message}"
    end
  end
  get_user_answers(no_exif_data)
end

def get_user_answers(arr)
  puts "We didn't find the EXIF data for the following pics => #{arr}"
  puts "Would you like to organize the remaining pics by the date the file was created?(Yes/No)"
  input = STDIN.gets.chomp
  
  if input == "Yes" 
    puts "Would you add the remaining pics to a different folder?(Yes/No)"
    answer = STDIN.gets.chomp
    if answer == "Yes"
      puts "...Done!"
      move_files(arr, "noexif")
    else
      puts "...Finished!"
      move_files(arr, "")
    end
  else
    puts "Done!"
  end
end


def move_files(arr, prefix)
  arr.each do |file|
    date = File.birthtime(file)
    year = date.strftime('%Y')
    month = date.strftime('%B')
    root_path = File.dirname(file)  

    path = File.join(root_path, prefix, year, month)

    FileUtils.mkdir_p(path)
    FileUtils.mv(file, path)
  end
end

organize_pics(*ARGV.map(&:to_s))
