require 'sinatra'
require 'net/http'
require 'uri'
require 'pry'
require 'json'
require 'sinatra/assetpack'


class Reports4freetoggl < Sinatra::Base

  configure do
    set :bind, '0.0.0.0'
    enable :sessions
    set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 365]
  end

  get '/' do
    "Hello, world!"
  end
  
  get '/login' do
    erb :loginform
  end

end
