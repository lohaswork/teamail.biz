class TopicApi < ApplicationApi

  resources :topics do
    desc "Return current user personal topics."

    params do
      requires :per_page, :type => Integer, :desc => "Page size for pagination"
      requires :page, :type => Integer, :desc => "Page number for pagination"
    end

    group :personal do
      params do
        requires :mailbox_type, :type => String, :values => ["all", "inbox"], :desc => "MailBox type"
      end

      get "/", jbuilder: 'topics/topic_list.jbuilder' do
        guard!
        topics = current_user.personal_topics(params[:mailbox_type])
        @topics = paginate topics
        @total_count = topics.size
      end
    end

    group :organization do
      params do
        optional :tags, :type => Array, :desc => "Tag IDs for filter"
      end

      get "/", jbuilder: 'topics/topic_list.jbuilder' do
        guard!
        topics = current_organization.topics.order_by_update
        if params[:tags].present?
          topics = topics.filter_by_tags(params[:tags])
          @topics = Kaminari.paginate_array(topics).page(params[:page]).per(params[:per_page])
        else
          @topics = paginate topics
        end
        @total_count = topics.size
      end
    end
  end
end
