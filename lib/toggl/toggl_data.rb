class TogglData

  public
  def get_reports user, parmas 
  
  uri = URI('https://toggl.com/reports/api/v2/details')
  
  perform user, params, uri
  
  end
  
  
  def get_user userdata, passdata
  uri = URI('https://www.toggl.com/api/v8/me?with_related_data=true')

  user = build_user_hash userdata, passdata

  params = {with_related_data: true}


  perform user, uri, params
  
  end






  private


  def build_user_hash username, userpass
    user = Hash.new
    user[:user] = username
    user[:pass] = userpass
    
    return user

  end


  def perform userdata, uri, params = {}
  
    # path2 = "?start_date=2015-09-01T00:00:00:00&end_date=2015-09-01T18:00:00:00"
    #star_date_submit = params[:star_date_submit].to_s + 'T00:00:00+00:00'
    #end_date_submit = params[:end_date_submit].to_s + 'T23:59:59+00:00' 
    #  end_date_submit = Date.parse(params[:end_date_submit] )
    #  end_date_submit = (end_date_submit + 1).to_s
    # puts end_date_submit
    # puts params
    #dates = {
    #  :start_date => params[:start_date_submit] + 'T00:00:00+00:00',
    #  :end_date => params[:end_date_submit] + 'T00:00:00+00:00'
    #}

    
   

    user = userdata[:user]
    pass = userdata[:pass]

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
     
    uri.query = URI.encode_www_form(params) if params 
    
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(user, pass)

    binding.pry
    
    res = http.request(request)
    case res
    when Net::HTTPSuccess then
      return JSON.parse(res.body)
    else
      return nil
    end
  
  end

end
