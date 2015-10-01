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
        
    register Sinatra::AssetPack
    assets do
      serve '/js', :from => 'asset/js'
      js :application, [
        '/js/jquery.js',
        '/js/foundation.min.js',
        '/js/easyredmine.js',
        '/js/vendor/*.js'
      ]
    
      serve '/css', :from => 'asset/css'
      css :application, ['/css/*.css']
    end    

  end

  get '/' do
    "Hello, world!"
  end
  
  get '/login' do
    erb :loginform
  end

  post '/loginvalidate' do
  puts params


  end


end
