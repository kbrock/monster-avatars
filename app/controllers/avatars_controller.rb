class AvatarsController < ApplicationController
  MOD_DATE = Time.parse('2011-1-1T120000').utc
  ETAG=MOD_DATE.hash
  def index
  end
  
  def show
    expires_in 1.week, 'max-stale' => 2.weeks, :public => true
    if stale? (:last_modified => MOD_DATE, :etag => MOD_DATE)
      a = Avatar.find(params[:id])
      a.generate
      send_file a.filename, :type => a.filetype, :url_based_filename => true, :disposition => 'inline'
      a.cleanup
    end
  end
end