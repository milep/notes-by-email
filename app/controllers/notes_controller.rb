class NotesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable

  def create
    contents = ""
    dropbox_session = DropboxSession.deserialize(current_user.dropbox_session)
    client = DropboxClient.new(dropbox_session, :app_folder)

    begin
      contents, metadata = client.get_file_and_metadata('/notes.org')
      parent_rev = metadata["rev"]
    rescue DropboxError => de
    end
    contents.insert(0, "#{params["body-plain"]}\n\n")
    contents.insert(0, "* #{params["subject"]}\n")

    client.put_file('/notes.org', contents, true, parent_rev)

    render :text => "ok"
  end

  private
  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end
end
