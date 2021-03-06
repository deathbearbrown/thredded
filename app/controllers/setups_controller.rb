class SetupsController < ApplicationController
  layout 'setup'
  helper_method :step, :setting_up

  def new
    case step
      when "1"
        @user = User.new
      when "2"
        @site = Site.new
      when "3"
        @messageboard = Messageboard.new
    end
  end

  def edit
  end

  def show
  end

  def create
    case step
    when "1"
      @user = User.create(params[:user]) 
      @user.superadmin = 1
      @user.save
      redirect_to '/2' if @user.valid?
      flash[:error] = "There were errors creating your user." and render :action => :new unless @user.valid?
    when "2"
      @user = User.last
      @site = Site.new params[:site]
      @site.user = @user
      @site.save
      redirect_to '/3' if @site.valid?
    when "3"
      @user = User.last
      @site = Site.last
      @messageboard = Messageboard.create(params[:messageboard].merge!({:theme => "default"}))
      if @messageboard.valid?
        @site.messageboards << @messageboard
        @site.save
        @user.admin_of @messageboard
        @messageboard.topics.create( :user => @user, 
                                     :last_user => @user, 
                                     :title => "Welcome to your site's very first thread",
                                     :posts_attributes => {
                                       "0" => {
                                         :content => "There's not a whole lot here for now.", 
                                         :user => @user, 
                                         :ip => "127.0.0.1", 
                                         :messageboard => @messageboard
                                       }
                                     })
        sign_in @user
        redirect_to root_path 
      end
    end
  end

  def update
  end

private

  def step
    @step ||= params[:step] || "1" 
  end

  def setting_up
    case step
      when "1"
        @setting_up = "User"
      when "2"
        @setting_up = "Site"
      when "3"
        @setting_up = "Messageboard"
    end
  end

end

