require 'sinatra'
require 'net/http'
require 'uri'
require 'pry'
require 'json'
require 'sinatra/assetpack'
require 'date'
require 'time'
require 'csv'

require_relative 'lib/toggl/toggl_login.rb'
require_relative 'lib/toggl/toggl_data.rb'
require_relative 'lib/toggl/toggl_organize_data.rb'
require_relative 'lib/toggl/toggl_date.rb'
require_relative 'lib/toggl/toggl_project.rb'

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
        '/js/easyredmine.js',
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
  
  def default_time (start_time = nil, end_time = nil)
    default_time = Hash.new
    time = Time.new
    default_time['start'] = (start_time == nil ) ? time.strftime("%Y-%m-%d") : start_time
    default_time['end']   = (end_time == nil) ?    time.strftime("%Y-%m-%d") : end_time
    return default_time
  end
  

  get '/' do
    redirect '/login'
  end
  
  get '/login' do
    @is_loged = is_authenticated?

    erb :loginform
  end

  post '/loginvalidate' do
    @is_loged = is_authenticated?


    user = TogglData.new.get_user(params[:mail],params[:password]) 
    
    binding.pry
    
    if user.nil?
      redirect '/login'
    else    
      session[:id]            = user['data']['id']
      session[:api_token]     = user['data']['api_token']
      session[:fullname]      = user['data']['fullname']
      session[:projects]      = TogglProject.new.create_toggl_projects_structure ( user['data']['projects'])
      session[:workspace_id]  = user['data']['workspaces'][0]['id']
      session[:user_agent]    = user['data']['email']
      redirect '/report/date'
    end
  end

  get '/report/date' do
    require_logged_in

    @is_loged = is_authenticated?
    @time_entries = nil
    @projects = session[:projects]
    @default_time = default_time

    erb :report
    
  end
  
  post '/report/date' do
    require_logged_in    

    @is_loged = is_authenticated?
    
    if params
    
      puts params
     
      kind = 'description'
      params[:end_date] = TogglDate.new.get_end_date_submit(params[:end_date])

      query_string = {
        #Project_id
        project_ids:    params[:project],
        user_agent:     session[:user_agent],
        workspace_id:   session[:workspace_id],
        since:          params[:start_date] + 'T00:00:00+00:00',
        "until"         => params[:end_date] + 'T00:00:00+00:00',
      }
      
      data_times   = TogglData.new.get_toggl_data session[:api_token],query_string   
       
      result_page_number = TogglOrganizeData.new.number_of_pages(data_times['total_count'])
      
      if data_times['total_count'] > data_times['per_page'] &&  result_page_number >= 2
       #data = Array.new
       #data = data_times['data']
       
       valores_retornados = Array.new
       
       (2..result_page_number).each do | index |
        puts "#{index}  index "
        query_string[:pages] = index
        returned_data = TogglData.new.get_toggl_data session[:api_token],query_string  
        
        valores_retornados << returned_data['data']
       end
       
        binding.pry
      
      end
      
      
      @default_time = default_time params[:start_date] , params[:end_date]
      
      @time_entries = TogglOrganizeData.new.build_data kind , data_times
    end
    @selected_project = params[:project].to_i
    @projects = session[:projects]
    #puts @projects    
      
    erb :report
  end

  get '/explain' do
    @is_loged = is_authenticated?
    
    erb :howto
  end


end
