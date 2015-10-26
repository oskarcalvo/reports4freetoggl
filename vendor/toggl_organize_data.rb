class TogglOrganizeData

  def build_data ( kind , data )
  
    if kind == 'description'
      results = data_organize_by_name (data)
      return results
    elsif kind == 'tag'
      results = data_organize_by_tag (data)
      return results
    end
      
  end
  
  private
  
  def data_organize_by_tag (data)
  
  end
  
  def data_organize_by_name (data)
    tasks = Hash.new

    data.each do | entry |
    
      description = entry['description']
      duration = entry['duration']

      if tasks[description].nil?
        
        tasks[description] = duration
      
      else

        newduration = tasks[description] + duration
        tasks[description] = newduration

      end
    end
    return tasks
  end

end
