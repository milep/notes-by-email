class NotesController < ApplicationController
  include ApplicationHelper
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

    new_content = ""
    body = params["body-plain"].strip
    body.gsub!(/\r\n/, "\n")
    enum = body.lines
    begin
      first_line = enum.next
      if uri?(first_line)
        new_content << "* [[#{first_line.strip}][#{params["subject"]}]]\n"
      else
        new_content << "* #{params["subject"]}\n"
        new_content << first_line
      end
      while new_content << enum.next; end
    rescue StopIteration => si
    end

    contents.insert(0, "#{new_content}\n\n")

    client.put_file('/notes.org', contents, true, parent_rev)

    render :text => "ok"
  end

  private
  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end
end
