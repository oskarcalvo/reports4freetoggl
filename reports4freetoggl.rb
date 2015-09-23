require 'sinatra'
require 'net/http'
require 'uri'
require 'pry'
require 'json'
require 'sinatra/assetpack'


class Reports4freetoggl < Sinatra::Base
  get '/' do
    "Hello, world!"
  end
end
