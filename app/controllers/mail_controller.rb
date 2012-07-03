class MailController < ActionController::Base
  def receive
    if user and messageboard
      @topic = find_or_create_topic
      @post = @topic.posts.new(content: params[:text], messageboard: messageboard, user: user)
      @post.source = 'email'
      @post.save
      if @topic and @post
        render nothing: true
      end
    end
  end

  private

  def user
    @user ||= User.find_by_email(params[:from])
  end

  def messageboard
    board_name = params[:to].split('@').first
    @messageboard ||= Messageboard.find_by_name(board_name)
  end

  def find_or_create_topic
    title = params[:subject].gsub(/(?:\[?(?:Fwd?|Re|RE)(?:\s*[:;]+\s*\]?)+|Re--|\(fwd\))+/, '')
    topic = Topic.where(title: title).first_or_create do |t|
      t.last_user = user
      t.user = user
      t.messageboard = messageboard
    end
    topic
  end
end
