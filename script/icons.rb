require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'RMagick'

root_dir = "#{RAILS_ROOT}/public/images/icons"

Dir.chdir(root_dir) do 
  Dir.glob('colors/*').each do |color_path|
    next if color_path.starts_with?('.')
    color = color_path.gsub(/colors\/(.*)\.png/, '\1')
    Dir.glob('overlays/*').each do |overlay_path|
      next if overlay_path.starts_with?('.')
      overlay = overlay_path.gsub(/overlays\/(.*)\.png/, '\1')
      icon_path = "#{color}_#{overlay}.png"

      color_image = Magick::Image.read(color_path).first
      overlay_image = Magick::Image.read(overlay_path).first
      
      icon_image = color_image.composite(overlay_image, 0, 0, Magick::OverCompositeOp)
      icon_image.write(icon_path)
    end
  end
end

exit

left_image = Magick::Image.read("#{RAILS_ROOT}/left.png").first
middle_image = Magick::Image.read("#{RAILS_ROOT}/middle.png").first
right_image = Magick::Image.read("#{RAILS_ROOT}/right.png").first
text = "Cows"

mode = 'plain'
drawable = Magick::Draw.new
drawable.pointsize = mode == 'plain' ? 13.0 : 13.25
drawable.font = ("#{RAILS_ROOT}/public/static/fonts/MyriadWebPro.ttf")
drawable.fill = mode == 'plain' ? 'black' : "#3C7C3D"
drawable.gravity = Magick::CenterGravity
metrics = drawable.get_type_metrics(text)

height = left_image.rows
width = metrics.width + left_image.columns + right_image.columns # calc this!

button_image = Magick::Image.new(width, height) do |img|
  img.background_color = 'none'
end

button_image.composite!(left_image, 0, 0, Magick::OverCompositeOp)
button_image.composite!(right_image, button_image.columns - right_image.columns, 0, 
  Magick::OverCompositeOp)
  
middle_section = Magick::Image.new(width - left_image.columns - right_image.columns, height)
middle_section.composite!(middle_image, 0, 0, Magick::OverCompositeOp)

button_image.composite!(middle_section, left_image.columns, 0, Magick::OverCompositeOp)

drawable.annotate(button_image, 0, 0, 0, 0, text)

button_image.write("button.png")
