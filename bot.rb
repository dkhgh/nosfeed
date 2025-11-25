require "nokogiri"
require "net/http"
require "uri"
require "json"
require "dotenv/load"
require "x"

# Initialize Twitter/X client
x_credentials = {
  api_key: ENV["X_API_KEY"],
  api_key_secret: ENV["X_API_SECRET"],
  access_token: ENV["X_ACCESS_TOKEN"],
  access_token_secret: ENV["X_ACCESS_TOKEN_SECRET"],
}
client = X::Client.new(**x_credentials)

FEED_URL = "https://feeds.nos.nl/nosnieuwsalgemeen"
STATE_FILE = "seen.json"

seen = File.exist?(STATE_FILE) ? JSON.parse(File.read(STATE_FILE)) : []

xml = Net::HTTP.get(URI(FEED_URL))
doc = Nokogiri::XML(xml)
items = doc.xpath("//item")

items.each do |item|
  guid = item.at_xpath("guid")&.text || item.at_xpath("link")&.text
  title = item.at_xpath("title")&.text
  link = item.at_xpath("link")&.text

  next if guid.nil? || seen.include?(guid)

  client.post("tweets", { text: "#{title}\n#{link}" }.to_json)
  puts "Tweeted: #{title} — #{link}"

  seen << guid
end

File.write(STATE_FILE, JSON.pretty_generate(seen))
