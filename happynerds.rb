APP_ROOT = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'haml'
require 'mongo'

set :root, APP_ROOT

include Mongo

db = Connection.new(ENV['DATABASE_URL']).db('happynerds')
if ENV['DATABASE_USER'] && ENV['DATABASE_PASSWORD']
  auth = db.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PASSWORD'])
end

configure :production do
  enable :raise_errors
end

get '/' do
  @sites = db['sites']
  haml :index
end

get '/view/:os' do
  redirect '/' unless %(linux mac windows).include? params[:os]
  @sites = db['sites']
  @os = params[:os]
  haml :os
end

get '/*' do
  redirect '/'
end


