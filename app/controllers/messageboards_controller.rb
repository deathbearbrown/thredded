class MessageboardsController < ApplicationController

  def index
    @messageboards = Messageboard.all
    @messageboard_name = @messageboard.present? ? @messageboard.name : THREDDED[:default_messageboard_name]
  end

  def show
    @messageboard = Messageboard.where(:name => params[:id]).first
    redirect_to topics_path(@messageboard)
  end

end