class Item
  @@count = 0
  attr_accessor :id, :category, :title, :img_url

  def save
    output_file = 'catalog.txt'
    data = [id, category, title, img_url].compact.reject(&:empty?)
    data = data.join("\t") + "\n"

    puts "Saving... #{data}"

    if @@count > 1
      File.open(output_file, 'a') { |file| file.write(data) }
    else
      File.open(output_file, 'w') { |file| file.write(data) }
    end

    @@count += 1
  end
end
