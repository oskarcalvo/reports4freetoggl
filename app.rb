require 'sinatra'
require 'net/http'
require 'uri'
require 'pry'
require 'json'
require 'sinatra/assetpack'
require 'date'
require 'time'

require_relative 'vendor/toggl_login.rb'
require_relative 'vendor/toggl_data.rb'
require_relative 'vendor/toggl_organize_data.rb'
require_relative 'vendor/toggl_date.rb'

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
        #'/js/foundation.min.js',
        '/js/easyredmine.js',
        #'/js/vendor/*.js',
        '/js/pickadate/lib/compressed/picker.js',
        '/js/pickadate/lib/compressed/picker.date.js',
        '/js/pickadate/lib/compressed/legacy.js'
      ]
    
      
      css :application, [
        '/css/easyredmine.css',
        '/css/pickadate/lib/compressed/themes/default.css',
        '/css/pickadate/lib/compressed/themes/default.date.css'
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
    redirect '/login'
  end
  
  get '/how-to' do
    erb :howto
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
      redirect '/report/date'
    end
  end

  get '/report/date' do
  
    require_logged_in
    
    @time_entries = nil
    erb :report
    
  end
  
  post '/report/date' do
    require_logged_in
    
    
    if params
      kind = 'description'
      params[:end_date_submit] = TogglDate.new.get_end_date_submit(params[:end_date_submit])
      data_times   = TogglData.new.get_toggl_data session[:api_token],params
      
      @time_entries = TogglOrganizeData.new.build_data kind , data_times
    end
      
    erb :report
  end


end
