class Parser
  attr_accessor :body

  def visit(url)
    puts "Visiting #{url}..."
    @body = Nokogiri::HTML(open(url))
  end

  def request(url:, method:, data: {})
    visit(url)
    sleep(rand(1..4))
    self.send(method, data)

  rescue StandardError => e
    puts "ERROR #{e.class}\n#{e.message}"
  end
end
