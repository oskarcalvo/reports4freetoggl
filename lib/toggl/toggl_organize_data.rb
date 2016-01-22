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
  
  def number_of_pages( total_amount )
    total_pages = total_amount/50  
    return total_pages+1  
  end
  
  private
  
  def data_organize_by_tag (data)
  
  end
  
  def data_organize_by_name (data)
    tasks = Hash.new
 
    data['data'].each do | entry |

      description = entry['description']
      duration = entry['dur']/1000

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
