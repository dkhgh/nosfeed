require "dotenv/load"
require "x"
require "json"

x_credentials = {
  api_key: ENV["X_API_KEY"],
  api_key_secret: ENV["X_API_SECRET"],
  access_token: ENV["X_ACCESS_TOKEN"],
  access_token_secret: ENV["X_ACCESS_TOKEN_SECRET"],
}

client = X::Client.new(**x_credentials)

post = client.post("tweets", '{"text":"Hello, World! (from @gem)"}')
