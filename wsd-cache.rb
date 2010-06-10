require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'open-uri'
require 'digest/md5'
require 'fileutils'

set :public, 'cache/'

post '/' do
  text = params["text"]
  hash = Digest::MD5.hexdigest(text)

  # If the graph has already been generated, update the mtime so that it
  # doesn't get expired and then serve it from the cache.
  if File.exist? "#{options.public}#{hash}.png"
    FileUtils.touch "#{options.public}#{hash}.png"
    redirect "/#{hash}.png"
  end

  response = Net::HTTP.post_form(URI.parse('http://www.websequencediagrams.com/index.php'), 'style' => 'modern-blue', 'message' => text)
  if response.body =~ /img: "(.+)"/
    url = "http://www.websequencediagrams.com/#{$1}"

    File.open("#{options.public}#{hash}.png", "w+") { |f| f << open(url).read }
  end
  redirect "/#{hash}.png"
end
