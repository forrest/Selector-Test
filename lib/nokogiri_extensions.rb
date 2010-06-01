module MyNokogiriClean
  def clean_css_path(path_type = :default)
    @path_type = path_type.to_s
    return css_path if @path_type=="xpath"
    
    return "" unless self.elem? 
    
    @elm_names = []
    elm = self
    while elm.name!="body" and elm.name!="document" and elm.parent
      
      if !elm["id"].blank?
        @elm_names << "#" + elm["id"]
        break if @path_type=="short"
      end
      
      if elm.contains_matching_sibling
        @elm_names << elm.name+":nth-child(#{elm.index_position})"
      else
        @elm_names << elm.name
      end

      elm = elm.parent
      elm.extend MyNokogiriClean
    end
    
    return current_path
  end
  
  def current_path
    return "body" if @elm_names.empty?
    str = @elm_names.reverse.join(" > ")
    str = str=~/^\#/ ? str : "body > "+str
  end
  
  def contains_matching_sibling
    return false unless self.elem? 
    return false if ["head", "html", "body"].include?(self.name)
        
    sibling = self.next_element
    while !sibling.nil? and sibling = sibling.next_element
      return true if sibling.name==self.name
    end
    
    sibling = self.previous_element
    while !sibling.nil? and sibling = sibling.previous_element
      return true if sibling.name==self.name
    end
    
    return false
  end
  
  def index_position
    count = 1
    sibling = self.previous_element
    return count if sibling.nil?
    count += 1
    while !sibling.nil? and sibling = sibling.previous_element
      count += 1
    end
    return count
  end
  
end