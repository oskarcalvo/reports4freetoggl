class TogglLogin

  def get_toggl_user_data (user,pass)

    uri = URI('https://www.toggl.com/api/v8/me')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(user, pass)
    res = http.request(request)

    case res
    when Net::HTTPSuccess then
      return JSON.parse(res.body)
    else
      return nil
    end

  end


end
