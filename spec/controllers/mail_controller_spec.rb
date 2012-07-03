require 'spec_helper'
require 'debugger'

describe MailController, 'POST receive' do
  before do
    @site = create(:site)
    @messageboard = create(:messageboard, site: @site)
    @user = create(:user)
    @user.member_of @messageboard
  end

  context 'with valid email and membership' do
    it 'should add a topic to the messageboard by the user' do
      post :receive, { from: @user.email, to: "#{@messageboard.name}@thredded.com", subject: 'A new thread', text: 'Replying via email.' }
      latest_topic = @messageboard.topics.first
      response.code.should == '200'
      latest_topic.title.should == 'A new thread'
      latest_topic.posts.first.content.should == 'Replying via email.'
    end

    context 'an already existing topic' do
      before do
        @existing_topic = create(:topic, title: 'Title', user: @user, messageboard: @messageboard)
        @existing_post = create(:post, content: 'First post!', user: @user, messageboard: @messageboard, topic: @existing_topic)
      end

      it 'can be replied to' do
        post :receive, { from: @user.email, to: "#{@messageboard.name}@thredded.com", subject: 'Title', text: 'Replying to existing thread' }
        should_have_processed_response
      end

      it 'can be replied to with a RE: prefix' do
        post :receive, { from: @user.email, to: "#{@messageboard.name}@thredded.com", subject: 'RE: Title', text: 'Replying to existing thread' }
        should_have_processed_response
      end
    end
  end
end

def should_have_processed_response
  latest_topic = @messageboard.topics.first
  response.code.should == '200'
  latest_topic.should == @existing_topic
  latest_topic.posts.count.should == 2
  latest_topic.posts.first.content.should == 'First post!'
  latest_topic.posts.last.content.should == 'Replying to existing thread'
  latest_topic.posts.last.source.should == 'email'
end
