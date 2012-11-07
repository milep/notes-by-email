class DropboxController < ApplicationController
  before_filter :authenticate_user!

  def authorize
    if not params[:oauth_token] then
      dbsession = DropboxSession.new(Settings.dropbox_app_key, Settings.dropbox_app_secret)

      session[:dropbox_session] = dbsession.serialize #serialize and save this DropboxSession

      #pass to get_authorize_url a callback url that will return the user here
      redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
    else
      # the user has returned from Dropbox
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      dbsession.get_access_token  #we've been authorized, so now request an access_token

      current_user.dropbox_session = dbsession.serialize
      current_user.save
      session.delete(:dropbox_session)

      redirect_to edit_user_registration_path
    end
  end
end
