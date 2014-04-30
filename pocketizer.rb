require 'httparty'
require 'dotenv'
Dotenv.load

@consumer_key = ENV["POCKET_CONSUMER_KEY"] || "setme"
@access_token = ENV["POCKET_ACCESS_TOKEN"] || "omgsetmeplz"

@url = ARGV.first

puts "needs access token! run authorizer.rb" unless @access_token

def add(url)
  request = HTTParty.post("https://getpocket.com/v3/add",
                          body: {
                            url: url,
                            consumer_key: @consumer_key,
                            access_token: @access_token
                          }.to_json,
                          headers: { 'Content-Type' => 'application/json' }
                          )

  response = request.message
  if response == "OK"
    puts "Successfully added #{ url } to Pocket."
  else
    puts "Something went wrong with #{ url }."
  end
end

if @url && @access_token
  if @url.include?(".xml")
    puts "Got a feed. Grabbing all items."
    require 'nokogiri'
    require 'open-uri'
    doc = Nokogiri::XML(open(@url))
    @links = doc.xpath('//item//link').map { |i| i.children.to_s }
    puts "Found #{ @links.count } URLs."
    @links.each { |link| add(link) }
  else
    add(@url)
  end
else
  puts "Missing argv for url"
end

