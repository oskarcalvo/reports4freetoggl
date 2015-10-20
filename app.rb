require 'sinatra'
require 'net/http'
require 'uri'
require 'pry'
require 'json'
require 'sinatra/assetpack'
require 'date'

require_relative 'vendor/toggl_login.rb'
require_relative 'vendor/toggl_data.rb'
require_relative 'vendor/toggl_organize_data.rb'

class Reports4freetoggl < Sinatra::Base
  
  configure do
    set :root, File.dirname(__FILE__)
    set :bind, '0.0.0.0'
    enable :sessions
    set :sessions, true
    set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 365]
    set :public_folder, Proc.new { File.join(root, "assets") }
    
     
    register Sinatra::AssetPack
    assets do
      serve '/js', :from => 'assets/js'
      serve '/css', :from => 'assets/css'      
      
      js :application, [
        '/js/jquery.js',
        '/js/foundation.min.js',
        '/js/easyredmine.js',
        '/js/vendor/*.js',
        '/js/pickadate/lib/compressed/picker.js',
        '/js/pickadate/lib/compressed/picker.date.js',
        '/js/pickadate/lib/compressed/legacy.js'
      ]
    
      
      css :application, [
        '/css/*.css',
        '/css/pickadate/lib/compressed/themes/*.css'        
      ]
    end    

  end

  def require_logged_in
    redirect('login') unless is_authenticated?
  end

  def is_authenticated?
    return !!session[:fullname]
  end


  get '/' do
    "Hello, world!"
  end
  
  get '/login' do
    erb :loginform
  end

  post '/loginvalidate' do
   
    user = TogglLogin.new.get_toggl_user_data(params[:mail],params[:password]) 

    if user.nil?
      redirect '/login'
    else    
      session[:api_token] = user['data']['api_token']
      session[:fullname]  = user['data']['fullname']
      redirect '/report'
    end
  end

  get '/report' do
  
    require_logged_in
    
    erb :report
    
  end
  
  post '/report' do

    require_logged_in
    
    if params
      kind = 'description'
      data_times   = TogglData.new.get_toggl_data(session[:api_token],params)
      output = TogglOrganizeData.new kind , data_times
    end
      
  end


end
