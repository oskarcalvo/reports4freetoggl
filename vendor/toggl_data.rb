class TogglData

  def get_toggl_data(user_api_token, dates = NIL)
  
    uri = URI('https://www.toggl.com/api/v8/time_entries')
    # path2 = "?start_date=2015-09-01T00:00:00:00&end_date=2015-09-01T18:00:00:00"
    dates = {
      :start_date => '2015-10-01T00:00:00+00:00',
      :end_date => '2015-10-15T00:00:00+00:00'
    }


    user = user_api_token
    pass = 'api_token'

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    uri.query = URI.encode_www_form(dates)
    request = Net::HTTP::Get.new(uri.request_uri)
    #puts "URI = #{uri.request_uri}"
    request.basic_auth(user, pass)
    res = http.request(request)
    # puts res.code
    times = JSON.parse(res.body)
    # puts times
    return times
  
  end


end
