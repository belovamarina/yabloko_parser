require_relative 'item'
require_relative 'parser'
require 'byebug'

class YablokoParser < Parser
  START_URL = 'http://www.a-yabloko.ru/'

  def parse
    visit START_URL

    body.xpath("//div[@id='catalog-menu'][2]/ul/li/a").each do |cat|
      request(url: "http://www.a-yabloko.ru#{cat[:href]}", method: :parse_category, data: { category: cat.text.strip })
    end
  end

  def parse_category(data)
    body.xpath("//tr[contains(@class, 'item')]/td[2]/a[@class='name']").each do |item|
      url = "http://www.a-yabloko.ru#{item[:href]}"
      request(url: url, method: :parse_item, data: data.merge(url: url))
    end
  end

  def parse_item(data)
    item = Item.new
    item.id = data[:url][/goods\/(\d+)/, 1]
    item.category = data[:category]
    item.title = body.xpath("//div[@class='sc-mobile-pad']/h1").text.strip

    image = body.at_xpath("//div[@class='img_list']/a/@href")&.text
    item.img_url = "http://www.a-yabloko.ru#{image}" if image

    item.save
  end
end
