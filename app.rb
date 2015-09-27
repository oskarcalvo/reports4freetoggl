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

  end


  get '/' do
    "Hello, world!"
  end
end
