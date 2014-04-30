require 'httparty'
require 'dotenv'
Dotenv.load

consumer_key = ENV["POCKET_CONSUMER_KEY"] || "setme"
redirect_uri = ENV["POCKET_REDIRECT_URI"] || "lol"

request = HTTParty.post("https://getpocket.com/v3/oauth/request",
                        body: {
                          consumer_key: consumer_key,
                          redirect_uri: redirect_uri
                        }.to_json,
                        headers: { 'Content-Type' => 'application/json' }
                        )

code = request.body.gsub("code=",'')

puts "Visit https://getpocket.com/auth/authorize?request_token=#{code}&redirect_uri=#{redirect_uri} to authorize the app. The redirect URI will probably fail."

blah = gets.chomp

auth = HTTParty.post("https://getpocket.com/v3/oauth/authorize",
                        body: {
                          consumer_key: consumer_key,
                          code: code
                        }.to_json,
                        headers: { 'Content-Type' => 'application/json' }
                        )

puts auth.body
