require 'exifr/jpeg'
require 'fileutils'
require 'date'
require 'time'

# TODO
# extract duplicated code and refactor

def organize_pics(st)
  path = st
  no_exif_data = []

  Dir.glob(path+'/*.*').each do |f|
    begin 
      if EXIFR::JPEG.new(f).exif?
        p f
        date = EXIFR::JPEG.new(f).date_time
        year = date.strftime('%Y')
        month = date.strftime('%B')
        x = FileUtils.mkdir_p(path+'/'+year+'/'+month)
        FileUtils.mv(f, x[0])     
      end
    rescue => e
      no_exif_data << f
      puts "errs for #{f}: #{e.message}"
    end
  end
  get_user_answers(no_exif_data)
end

def get_user_answers(arr)
  puts "We didn't find the EXIF data for the following pics#{arr}"
  puts "Would you like to organize the remaining pics by the date the file was created?(Yes/No)"
  answer = STDIN.gets.chomp
  
  if answer == "Yes" 
    puts "Would you add the remaining pics to a different folder named [YEAR]*?(Yes/No)"
    answer2 = STDIN.gets.chomp
    if answer2 == "Yes"
      puts "We are adding the remaining pics to a separate folder... Done!"
      organize_with_note(arr)
    else
      puts "We are adding the remaining pics to the same folder as the others... Done!"
      organize_by_file_data(arr)
    end
  else
    puts "Ok. Thank you"
  end
end

def organize_by_file_data(arr)
  arr.each do |file|
    date = File.birthtime(file)
    year = date.strftime('%Y')
    month = date.strftime('%B')
    path = File.dirname(file)  

    f = FileUtils.mkdir_p(path+'/'+year+'/'+month)
    FileUtils.mv(file, f[0])
  end
end

def organize_with_note(arr)
  arr.each do |file|
    date = File.birthtime(file)
    year = date.strftime('%Y')
    month = date.strftime('%B')
    path = File.dirname(file)
   
    f = FileUtils.mkdir_p(path+'/'+year+'*/'+month)
    FileUtils.mv(file, f[0])
  end
end

organize_pics(*ARGV.map(&:to_s))
