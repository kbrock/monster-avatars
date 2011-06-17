class AvatarsController < ApplicationController
  MOD_DATE = Time.parse('2011-1-1T120000').utc
  ETAG=MOD_DATE.hash
  def index
  end
  
  def show
    expires_in 1.week, 'max-stale' => 2.weeks, :public => true
    if stale? :last_modified => MOD_DATE, :etag => MOD_DATE
      @avatar = Avatar.find(params[:id])
      @avatar.generate
      send_file @avatar.filename, :type => @avatar.filetype, :url_based_filename => true, :disposition => 'inline'
      @avatar.cleanup
    end
  end
end