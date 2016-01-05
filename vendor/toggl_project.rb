class TogglProject

  def create_toggl_projects_structure(projects)
    newprojects = Hash.new
    
    projects.each do | project |
      newprojects[project['id']] = project['name']
    end
    
    return newprojects  
  end 
end
