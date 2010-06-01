class MainController < ApplicationController
  
  def index
    
  end
  
  def frame
    url = AbsoluteUrlGenerator.make_link_absolute(params[:url])
    
    body = PageFetcher.fetch(url)
    content = ContentCleaner.clean(url, body)
    
    render :text => content
  end
  
  
end
