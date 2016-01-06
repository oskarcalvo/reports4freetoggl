class TogglData


  def get_toggl_data(user_api_token, params = NIL)
  
    uri = URI('https://toggl.com/reports/api/v2/details')
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

    user = user_api_token
    pass = 'api_token'

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(user, pass)
    res = http.request(request)
    times = JSON.parse(res.body)

    return times
  
  end

end
