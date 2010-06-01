class ContentCleaner
  load "nokogiri_extensions.rb"
  
  NORMALIZABLE = [:src, :target, :href, :file]
  SCRIPT_ATTRIBUTES = ["onclick", "onmouseover", "onmouseout", "onchange", "onsubmit", "onload"]
  
  def self.clean(original_url, body)
    @original_url = original_url
    @doc = Nokogiri::HTML(body)
    
    normalize
    remove_scripts
    remove_links
    add_css_selectors
    add_frame_script
    
    @doc.to_s
  end
  
  private
  
  def self.normalize
    NORMALIZABLE.each{|attribute|
      @doc.search("[#{attribute.to_s}]").each{|elm| normalize_attribute(elm, attribute) }
    }
  end
  
  def self.normalize_attribute(element, attribute)
    unless element[attribute].blank?
      original_url = element[attribute]
      normalized_url = AbsoluteUrlGenerator.make_link_absolute(original_url, @original_url)
      element[attribute.to_s] = normalized_url
    end
  end
  
  def self.remove_links
    @doc.search("a").each{|e| 
      e["href"] = "#"
      e["target"] = ""
    }
  end
  
  def self.remove_scripts
    @doc.search("script").each{|e| e.remove }
    SCRIPT_ATTRIBUTES.each{|attr|
      @doc.search("[#{attr}]").each{|e| e.remove_attribute(attr)}
    }
  end
  
  def self.add_css_selectors
    @doc.traverse{|e|
      if e.elem? and e.name!="head" and e.parent.name!="head"
        e.extend MyNokogiriClean
        e["cm_xpath"] = e.clean_css_path(:xpath).gsub("html > ", "")
        e["cm_css_path"] = e.clean_css_path(:short).gsub("html > ", "")
      end
    }
  end
  
  def self.add_frame_script
    @doc.search("head").each{|e|
      e.after "<script src=\"/javascripts/prototype.js\"></script>\n"+
              "<script src=\"/javascripts/inframe_scripts.js\"></script>\n"+
              "<link type=\"text/css\" href=\"/stylesheets/inframe_styles.css\" rel=\"stylesheet\" media=\"screen\" />"
    }
  end
  
end