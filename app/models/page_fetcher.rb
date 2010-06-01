class PageFetcher
  require 'net/http'
  
  def self.fetch(url)
    @url_obj = Addressable::URI.parse(AbsoluteUrlGenerator.make_link_absolute(url))
    @domain = @url_obj.host
    @path = @url_obj.path.dup
    @path << "?"+@url_obj.query if !@url_obj.query.blank? and !@path.include?("?")
    
    req = Net::HTTP::Get.new(@path)
    res = Net::HTTP.start(@domain, 80){|http| http.request(req) }
    res.body
  end
  
end