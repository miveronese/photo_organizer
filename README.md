# Photo Organizer


A Ruby script to organize your pictures by date based on their EXIF metadata
It uses the [exifr gem (https://github.com/remvee/exifr)]

## How to use it

Run in your terminal:

  `ruby organizer.rb [path to the folder you want to organize]`

If a picutre doesn't have EXIF info, you will see, in the prompt, an option to use the date when the file was created.

The pictures will be moved to folders and subfolders based on the Year and Month they were created, like:

    [Year] > [Month]
    
    2017 > January  > Bla.jpg
         > February > Ble.jpg


    2010 > April  > Foo.jpg
                    Bar.jpg
