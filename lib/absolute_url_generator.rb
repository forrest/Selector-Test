class AbsoluteUrlGenerator
  def self.make_link_absolute(link, parent_url = "")
    return link if link=~/^mailto:|^javascript:/
    
    set_parent_url_obj(parent_url)
    set_link_obj(link)
    
    if @parent_url_obj and @link_obj.relative?
      @link_obj = @parent_url_obj.join(@link_obj)
    end 
    
    @link_obj.normalize!
    
    if @link_obj.path.empty?
      @link_obj.path = "/"
    end
    
    if @parent_url_obj and @link_obj.normalized_host.blank?
      @link_obj.host = @parent_url_obj.normalized_host
    end
    
    final_url = @link_obj.to_s.sub(/^(.+)\:\/\//, "")
    
    final_url.gsub!(/\:80|\:8991/, "")
    
    final_url.gsub!(/\#.*/, "")
    
    final_url.gsub!(/\/+/, "/")
    
    final_url.gsub!(/^(.*?)@/, "")
  
    final_url = "http://"+final_url
    
    return final_url
  end
  
  
  def self.get_folder_path(file_path)
    
    #clean url
    cleaned_path = self.make_link_absolute(file_path)
    
    #remove query params
    if cleaned_path =~ /(.+)\?(.*)/
      cleaned_path = $1
      
      return cleaned_path
    end
    
    folder_url = Addressable::URI::parse(cleaned_path)
    
    folder_path = folder_url.path
    
    if not folder_path.blank?

      if folder_path =~ /(.+)\/$/ #strip ending slash if exists
        folder_path = $1
      end 

      if folder_path =~ /(.*\/)(.*?)/ #grab everything but the last basename
        folder_path = $1
      end
      
      unless folder_path =~ /\/$/ #add ending slash back on
        folder_path << "/"
      end

      folder_url.path = folder_path
    end
    
    "http://"+folder_url.host + folder_path
  end
  
  def self.get_folder_name(file_path)
    folder_path = self.get_folder_path(file_path)
    folder_url = Addressable::URI::parse(folder_path)
    folder_name = File.basename(folder_url.path)
    return folder_name.blank? ? "/" : folder_name
  end
  
  private
  
  def self.set_parent_url_obj(parent_url)
    if(parent_url.nil? || parent_url.empty?)
      return #raise ArgumentError, "The parent_url can not be empty"
    end
    
    @parent_url_obj = Addressable::URI::parse(parent_url)
  end
  
  def self.set_link_obj(link)
    if(link.nil? || link.empty?)
      raise ArgumentError, "The link can not be empty"
    end
    
    @link_obj = Addressable::URI::parse(link)
  end
  
end