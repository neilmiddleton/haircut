require 'sinatra'
require 'sequel'
require 'haml'
require 'addressable/uri'
require 'sinatra/reloader' if ENV.fetch("RACK_ENV", "production") == "development"

DB = Sequel.connect(ENV.fetch("DATABASE_URL", "postgres://localhost/shortener"))

require_relative 'models/url'

get '/' do
  haml :shorten
end

post '/shorten' do
  uri = Addressable::URI.parse(params["url"])
  if ["http","https","ftp"].include?(uri.scheme)
    @url = Url.create(url: params["url"])
    @url.update(:short_url => @url.id.to_s(36))

    haml :shortened
  else
    raise "Invalid URI = #{params["url"]}"
  end
end

get '/:short_url' do
  @url = Url.filter(:short_url => params[:short_url]).first

  if !@url.nil?
    redirect to(@url.url)
  else
    haml :not_found
  end
end
