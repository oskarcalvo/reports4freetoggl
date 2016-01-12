class TogglDate
  public
  def get_end_date_submit(date)
    newdate = Date.parse(date)
    newdate = (newdate + 1).to_s
    return newdate.to_s  
  end
end
