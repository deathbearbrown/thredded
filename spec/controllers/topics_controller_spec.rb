require 'spec_helper'
require 'debugger'

describe TopicsController do
  describe "GET 'index'" do
    before do
      @user = create(:user)
      @site = create(:site)
      @messageboard = create(:messageboard, site: @site)
      @topic = create(:topic, messageboard: @messageboard)
      @post = create(:post, topic: @topic)
      controller.stubs(:get_topics).returns([@topic])
      controller.stubs(:get_sticky_topics).returns([])
      controller.stubs(:can?).returns(true)
      controller.stubs(:current_user).returns(@user)
      controller.stubs(:site).returns(@site)
    end
    it 'should render index' do
      get :index, messageboard_id: @messageboard.id
      response.should be_success
      response.should render_template('index')
    end
    it 'should render search' do
      get :index, messageboard_id: @messageboard.id, q: 'hi'
      response.should be_success
      response.should render_template('search')
    end
  end
end
