class AddDropboxSessionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_session, :string
  end
end
