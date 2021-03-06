# encoding: utf-8
class DiscussionsController < ApplicationController
  before_filter :login_required, :organization_required

  def create
    @topic = Topic.find(params[:topic_id])
    if params[:add_informal_user_button]
      # Validate invite emails and add member to the topic and current organization by emails
      emails = get_valid_emails(params[:informal_user_emails])
      current_organization.add_informal_member(emails)
      @topic.add_informal_member(emails)
      participators = get_colleagues.concat @topic.informal_participators

      respond_array = []
      respond_array << "select-user-for-discussion" << get_rendered_string('shared/user_select_for_discussion', { topic: @topic, participators: participators })
      render :json => { update: Hash[*respond_array] }
    else
      selected_emails = params[:selected_emails] || []

      # Get discussion notify party from selected_emails,
      #   then send discussion notifications
      discussion = Discussion.create_discussion(login_user, @topic, selected_emails, params[:content])

      if files = params[:discussion_upload_files].split(',')
        discussion.add_files(files)
      end

      DiscussionNotifierWorker.perform_async(discussion.id, selected_emails)
      participators = get_colleagues.concat @topic.informal_participators

      respond_array = []
      respond_array << "new-discussion" << get_rendered_string('topics/new_discussion', { topic: @topic.reload, participators: participators })
      respond_array << "discussion-list" << get_rendered_string('topics/discussion_list', { discussions: @topic.reload.discussions })
      render :json => { update: Hash[*respond_array] }
    end
  end
end
