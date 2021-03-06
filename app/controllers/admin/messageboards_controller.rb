class Admin::MessageboardsController < ApplicationController
  load_and_authorize_resource :find_by => :name
  before_filter :messageboard, :only => :show

  def index
    unless can? :read, site
      redirect_to new_user_session_url(host: site.cached_domain)
    end
  end

  def edit
  end

  def update
    messageboard.update_attributes(params[:messageboard])
    redirect_to edit_admin_site_messageboard_path(site.id, messageboard.id)
  end
end
