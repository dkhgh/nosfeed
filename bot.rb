require "nokogiri"
require "net/http"
require "uri"
require "json"

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

  puts "[NEW] #{title} — #{link}"
  seen << guid
end

File.write(STATE_FILE, JSON.pretty_generate(seen))
