NotesByEmail::Application.routes.draw do
  match "notes/create/:auth_token" => "notes#create", :via => :post

  devise_for :users, :controllers => { :registrations => "users/registrations" }

  match 'db/authorize' => "dropbox#authorize", :via => :get, :as => :dropbox_authorize

  root :to => "home#index"
end
