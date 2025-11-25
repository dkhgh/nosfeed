ruby - <<'EOF'
require "net/http"
require "uri"

uri = URI("https://feeds.nos.nl/nosnieuws")
res = Net::HTTP.get_response(uri)

puts "Status: #{res.code}"
puts "Location: #{res['location'].inspect}"
EOF
