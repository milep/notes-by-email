class NotesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable

  def create
    contents = ""
    begin
      contents, metadata = client.get_file_and_metadata('/notes.org')
      parent_rev = metadata["rev"]
    rescue DropboxError => de
    end
    contents.prepend "#{params["body-plain"]}\n\n"
    contents.prepend "* #{params["subject"]}\n"

    dropbox_session = DropboxSession.deserialze(current_user.dropbox_session)
    client = DropboxClient.new(dropbox_session, :app_folder)
    client.put_file('/notes.org', contents, true, parent_rev)

    render :text => "ok"
  end

  private
  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end
end
