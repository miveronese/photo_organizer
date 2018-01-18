require 'exifr/jpeg'
require 'fileutils'
require 'date'
require 'time'

def organize_pics(dir)
  no_exif = []

  Dir.glob(dir+'/*.*').each do |file|
    begin 
      if EXIFR::JPEG.new(file).exif?
        date = EXIFR::JPEG.new(file).date_time
        year = date.strftime('%Y')
        month = date.strftime('%B')
        root_path = File.dirname(file)

        path = File.join(root_path, year, month)

        FileUtils.mkdir_p(path)
        FileUtils.mv(file, path)     
      end
    rescue => e
      no_exif << file
      # puts "errs for #{f}: #{e.message}"
    end
  end
  get_user_answers(no_exif)
end

def get_user_answers(arr)
  puts "The following pics don't have exif date_time:"
  puts "\n" 
  p arr
  puts "\n"
  puts "Want to organize the remaining pics based on the date the file was created?(Yes/No)"
  input = STDIN.gets.chomp
  
  if input == "Yes" 
    puts "Want to add the remaining pics to a different folder named noexif ?(Yes/No) \n"
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
