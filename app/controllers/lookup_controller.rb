class LookupController < ApplicationController
  
  def index
  	if @su_name = params[:su_name]
  		
      url = URI.parse('http://elophant.com/api/v1/euw/getSummonerNames?summonerIds=' +     @player + '&key=APIKey')
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
      @b = res.body 
     end
  end
end
