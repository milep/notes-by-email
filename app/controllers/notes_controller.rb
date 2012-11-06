class NotesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable

  def create
    Rails.logger.info "###########"
    Rails.logger.info params["subject"]
    Rails.logger.info params["body-plain"]
    Rails.logger.info "###########"
    render :text => "ok"
  end

  private
  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end
end
