# encoding: utf-8
#TODO: update the cleaner
require 'spec_helper'
require 'helpers'

describe "the topics action" do
  include Helpers
  describe "user on topic list page" do
    context "user on the topic list page", :js => true do
      it  "should see the topic title" do
        user = create(:normal_user)
        organization = user.default_organization
        login_with(user.email, user.password)
        page.should have_content '登出'
        visit organization_topics_path
        page.should have_content organization.topics.first.title
      end
    end

    context "user not login go the topic title list page" do
      it "should not see the topic title" do
        organization = create(:normal_user).default_organization
        visit organization_topics_path
        page.should_not have_content organization.topics.first.title
      end
    end

    context "not the organization user go to the topic list", :js => true do
      it "should not saw the topics title" do
        organization = create(:organization_with_topic, name:"new-organization")
        user = create(:normal_user)
        login_with(user.email, user.password)
        visit organization_topics_path
        page.should_not have_content organization.topics.last.title
      end
    end
  end

  describe "user create new topic", :js => true do
    before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      mock_login_with(@user.email)
      page.should have_content '登出'
      visit organization_topics_path
    end

    describe "user can open a create topic field" do
      context "user click the new topic buttion" do
        it "should have a field for new topic" do
          page.should have_button "创建新话题"
          click_on "创建新话题"
          page.should have_selector "#new-topic-form"
        end

        it "should saw the user select checkbox" do
          page.should have_button "创建新话题"
          click_on "创建新话题"
          find('#select-user-for-topic').should have_content(@organization.users.last.email_name)
        end

        it "should not have current user name in the select user checkbox" do
          page.should have_button "创建新话题"
          click_on "创建新话题"
          find('#select-user-for-topic').should_not have_content(@user.email_name)
        end
      end

      context "user reopen the field" do
        it "should keep the text" do
          click_on "创建新话题"
          fill_in "title", :with => "test title"
          find("#modal-close").trigger('click')
          page.should_not have_link "modal-close"
          click_on "创建新话题"
          find_field('title').value == "test title"
        end
      end
    end

    describe "user create new topic", :js => true do
      context "user create success" do
        it "should see the new topic on the list" do
          click_on "创建新话题"
          sleep 0.5
          fill_in "title", :with => "test title"
          click_button "创建"
          page.should have_content "话题创建成功"
          visit organization_topics_path
          page.should have_content "test title"
        end

        it "should add the selected user into topic members" do
          click_on "创建新话题"
          sleep 0.5
          fill_in "title", :with => "test title"
          find(:xpath, '//*[@id="select-user-for-topic"]/label[9]/input').set(true)
          click_button "创建"
          page.should have_content "话题创建成功"
          visit organization_topics_path
          page.should have_content "test title"
          wait_for_ajax
          @organization.reload.topics.last.users.should include(@organization.users.last)
        end

        it "should default add the current user as member" do
          click_on "创建新话题"
          sleep 0.5
          fill_in "title", :with => "test title"
          click_button "创建"
          page.should have_content "话题创建成功"
          visit organization_topics_path
          page.should have_content "test title"
          @organization.topics.last.users.should include(@user)
        end

        it "should select all of the users by select all checkbox" do
          click_on "创建新话题"
          sleep 0.5
          fill_in "title", :with => "test title"
          find(:xpath, "//*[@id='select-user-for-topic']/div/span").click
          click_button "创建"
          page.should have_content "话题创建成功"
          wait_for_ajax
          expect(@organization.reload.topics.last.users.length).to eq 10
        end

      end

      context "user create success with a discussion" do
        it "shold see the discussion size change" do
          click_on "创建新话题"
          sleep 0.5
          fill_in "title", :with => "test title"
          editor_fill_in :in => '#new-topic-form', :with => "this is test discussion"
          click_button "创建"
          page.should have_content "话题创建成功"
          visit organization_topics_path
          page.should have_content "test title"
          page.should have_content 1
        end
      end

      context "user create failed" do
        it "should see error message" do
          click_on "创建新话题"
          click_button "创建"
          page.should have_content "请输入标题"
        end
      end
    end
  end

  describe "user on topic detail page", :js => true do
    before do
      user = create(:normal_user)
      @organization = user.default_organization
      login_with(user.email, user.password)
      page.should have_content '登出'
      visit organization_topics_path
    end

    context "click the topic title" do
      it "should go to the topic detail page" do
        click_on @organization.topics.last.title
        current_path.should == topic_path(@organization.topics.last)
        page.should have_content @organization.topics.last.discussions.last.content
      end
    end

    context "user create a new discussions" do
      it "should see the content on the page" do
        visit topic_path(@organization.topics.first)
        editor_fill_in :in => 'div#new-discussion-form', :with => "user create a discussion"
        click_button "回复"
        page.should have_content "user create a discussion"
      end
    end

    context "user fill in nothing for discussion" do
      it "should see the error message" do
        visit topic_path(@organization.topics.first)
        click_button "回复"
        page.should have_content "请输入回复内容"
      end
    end

    context "user create topic with blank content success" do
      it "should see the R.T for content" do
        click_on "创建新话题"
        sleep 0.5
        fill_in "title", :with => "test title"
        click_button "创建"
        page.should have_content "话题创建成功"
        visit organization_topics_path
        page.should have_content "test title"
        click_on "test title"
        page.should have_content "如题"
      end
    end
  end

  describe "go to discussion page with selected user", :js => true do
    before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      mock_login_with(@user.email)
      page.should have_content '登出'
      visit organization_topics_path
    end

    context "user go to discussion page saw the select users" do
      it "should see the last discussion member default selected " do
        click_on "创建新话题"
        fill_in "title", :with => "test title"
        sleep 0.5
        find(:xpath, "//*[@id='select-user-for-topic']/label[9]/input").set(true)
        click_button "创建"
        page.should have_content "话题创建成功"
        visit organization_topics_path
        page.should have_content("test title")
        click_on "test title"
        page.should have_button "回复"
        find(:xpath, "//*[@id='select-user-for-discussion']/label[9]/input").should be_checked
      end
    end

    describe "user create discussion with select user" do
      before do
        click_on "创建新话题"
        sleep 0.5
        fill_in "title", :with => "test select user"
        click_button "创建"
        page.should have_content "话题创建成功"
        visit organization_topics_path
        click_on "test select user"
        page.should have_button("回复")
      end

      context "select a user manully" do
        it "should add the user to the discussion" do
          editor_fill_in :in => '#new-discussion-form', :with => "user create a discussion for discussion users"
          checkbox = find(:xpath, "//*[@id='select-user-for-discussion']/label[9]/input")
          checkbox.set(true)
          click_button "回复"
          page.should have_content "user create a discussion for discussion users"
          Discussion.last.users.should include(User.find_by_email(checkbox.value))
        end

        it "should add the user to the topic member" do
          Topic.last.users.should_not include(@organization.users.last)
          editor_fill_in :in => '#new-discussion-form', :with => "user create a discussion for topic users"
          checkbox = find(:xpath, "//*[@id='select-user-for-discussion']/label[9]/input")
          checkbox.set(true)
          click_button "回复"
          page.should have_content "user create a discussion for topic users"
          Topic.last.users.should include(User.find_by_email(checkbox.value))
        end

        it "should add all users by select all" do
          Topic.last.users.size.should == 1
          editor_fill_in :in => '#new-discussion-form', :with => "user create a discussion for topic users"
          find(:xpath, "//*[@id='select-user-for-discussion']/div/span").click
          click_button "回复"
          page.should have_content "user create a discussion for topic users"
          Topic.last.users.length.should == 10
        end

        it "should add set the last created user as default checked" do
          Topic.last.users.size.should == 1
          editor_fill_in :in => '#new-discussion-form', :with => "user create a discussion for discussion users"
          checkbox = find(:xpath, "//*[@id='select-user-for-discussion']/label[9]/input")
          checkbox.set(true)
          click_button "回复"
          page.should have_content "user create a discussion for discussion users"
          Topic.last.users.size.should == 2
          #expect(find(:xpath, "//*[@id='select-user-for-discussion']/input[10]")).to be_checked
        end
      end
    end
  end

  describe "user on the own topics" do
    context "user not login in" do
      it "should redirect to the login page" do
        visit personal_topics_path
        current_path.should == login_path
      end
    end

    describe "user already login", :js => true do
      before do
        @user = create(:normal_user)
        login_with(@user.email, @user.password)
        page.should have_content '登出'
      end
      context "user go to topics page" do
        it "should have the topic title" do
          visit personal_topics_path
          page.should have_content @user.topics.first.title
        end
      end

      context "user click on the navybar" do
        it "should have the topic title" do
          within('.personal-inbox') do
            click_on "所有"
          end
          page.should have_content @user.topics.first.title
        end
      end

      context "when no colleagues of the user" do
        it "should have no select-all checkbox" do
          visit personal_topics_path
          click_on "创建新话题"
          page.should have_selector "#new-topic-form"
          find('#select-user-for-topic').should_not have_content("全选")
        end
      end

    end

    describe "user create new topic on the personal space page", :js => true do
      before do
        @organization = create(:organization_with_multi_users)
        @user = @organization.users.first
        mock_login_with(@user.email)
        page.should have_content "登出"
      end

      describe "user can open a create topic field" do
        context "user click the new topic buttion" do
          it "should have a field for new topic" do
            page.should have_button "创建新话题"
            page.should_not have_selector "#new-topic-form"
            click_on "创建新话题"
            page.should have_selector "#new-topic-form"
          end

          it "should saw the user select checkbox" do
            page.should have_button "创建新话题"
            click_on "创建新话题"
            find('#select-user-for-topic').should have_content(@organization.users.last.email_name)
          end

          it "should not have current user name in the select user checkbox" do
            page.should have_button "创建新话题"
            click_on "创建新话题"
            find('#select-user-for-topic').should_not have_content(@user.email_name)
          end
        end

        context "user reopen the field" do
          it "should keep the text" do
            click_on "创建新话题"
            fill_in "title", :with => "test title"
            find("#modal-close").trigger('click')
            page.should_not have_link "modal-close"
            click_on "创建新话题"
            find_field('title').value == "test title"
          end
        end
      end

      describe "user create new topic on personal space" do
        context "user create success" do
          it "should see the new topic on the list" do
            click_on "创建新话题"
            sleep 0.5
            fill_in "title", :with => "test title"
            click_button "创建"
            page.should have_content "话题创建成功"
            visit personal_topics_path
            page.should have_content "test title"
            page.should_not have_selector "#new-topic-form"
          end

          it "should add the selected user into topic members" do
            click_on "创建新话题"
            fill_in "title", :with => "test title"
            sleep 0.5
            find(:xpath, "//*[@id='select-user-for-topic']/label[9]/input").set(true)
            click_button "创建"
            page.should have_content "话题创建成功"
            visit personal_topics_path
            page.should have_content "test title"
            @organization.reload.topics.last.users.should include(@organization.users.last)
          end

          it "should default add the current user as member" do
            click_on "创建新话题"
            sleep 0.5
            fill_in "title", :with => "test title"
            click_button "创建"
            page.should have_content "话题创建成功"
            visit personal_topics_path
            page.should have_content "test title"
            @organization.topics.last.users.should include(@user)
          end

          it "should select all of the users by select all checkbox" do
            click_on "创建新话题"
            sleep 0.5
            fill_in "title", :with => "test title"
            page.should have_selector(:xpath, "//*[@id='select-user-for-topic']/div/span")
            find(:xpath, "//*[@id='select-user-for-topic']/div/span").click
            click_button "创建"
            wait_for_ajax
            expect(@organization.reload.topics.last.users.length).to eq 10
            #expect(@organization.reload.topics.last.users.length).to eq(@organization.reload.users.length)
          end
        end

        context "user create success with a discussion" do
          it "shold see the discussion size change" do
            click_on "创建新话题"
            sleep 0.5
            fill_in "title", :with => "test title"
            editor_fill_in :in => '#new-topic-form', :with => "this is test discussion"
            click_button "创建"
            page.should have_content "话题创建成功"
            visit personal_topics_path
            page.should have_content "test title"
            page.should have_content 1
          end
        end

        context "user create failed" do
          it "should see error message" do
            click_on "创建新话题"
            sleep 0.5
            click_button "创建"
            page.should have_content "请输入标题"
          end
        end
      end
    end

    describe "user in personal_topics_inbox_path", :js => true do
      before do
        @user = create(:normal_user)
        login_with(@user.email, @user.password)
        page.should have_content '登出'
        visit personal_topics_inbox_path
      end

      it "should see archive button disabled" do
        find('#archive-submit')[:disabled].should eq "disabled"
      end

      it "should be able to click archive button when topics are selected" do
        find(:xpath, "(//div[@id='topic-list']//input[@type='checkbox'])[1]").set(true)
        find(:css, '#archive-submit')[:disabled].should_not eq "disabled"
      end

      it "should disappeared when the topic is archived" do
        checkbox = find(:xpath, "(//div[@id='topic-list']//input[@type='checkbox'])[1]")
        checkbox.set(true)
        topic = Topic.find(checkbox.value)
        page.should have_content topic.title
        click_button '归档'
        page.should_not have_content topic.title
      end
    end
  end
end
