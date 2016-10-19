require 'rmagick'
require 'fastimage'
include Magick

def half_size(folder)
  #ex. direct path '/Users/Gabe/Dropbox/Ecuador/'
  image_array = Dir[folder + "*"]
  Dir.mkdir(folder + "small") unless File.exists?(folder + "small")
  image_array.each do |i|
    if i.downcase.include?('.jpg')
      img = ImageList.new(i)
      width,height = FastImage.size(i) unless i.include?("(")

      if img.orientation.to_s != 'TopLeftOrientation'
        img.auto_orient!
        img.write(i)
      end

      File.rename(i, i.downcase.sub('.jpg', " (#{width}x#{height}).jpg")) unless i.include?("(")

      unless File.exists?(folder + "small/" + File.basename(i))
        small = img.scale(0.1)
        small.write(folder + "small/" + File.basename(i).downcase.sub(/[ (].*[)]/, ''))
        puts "#{image_array.index(i)}/#{image_array.count}"
      end
      img.destroy!
    else
      puts "skipping #{i}"
    end
  end
end
