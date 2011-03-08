class AvatarsController < ApplicationController
  MOD_DATE = DateTime.parse('2011-1-1T120000').utc
  def index
  end
  
  def show
    #if stale? (:last_modified => MOD_DATE)
      a = Avatar.find(params[:id])
      a.generate
      send_file a.filename, :type => a.filetype, :disposition => 'inline'
      a.cleanup
    #end
  end
end