module API
  class Base < Grape::API
    include APIGuard
    include Grape::Kaminari
    version 'v1', using: :path
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    helpers do
      def current_user
        @current_user ||= OauthAccessToken.find_by(:token, params[:access_token]).user
      end

    end

    resources :topics do
      # Todo: paginate & tag filter
      desc "Return current user personal topics."
      params do
        optional :tags, :type => Array, :desc => "Tag IDs for filter"
        requires :mailbox_type, :type => String, :desc => "MailBox type"
        requires :per_page, :type => Integer, :desc => "Page size for pagination"
        requires :page, :type => Integer, :desc => "Page number for pagination"
      end
      get "/personal", jbuilder: 'topics/personal.jbuilder' do
        guard!
        topics = current_user.personal_topics(params[:mailbox_type])
        if params[:tags].present?
          @topics = Kaminari.paginate_array(topics.reject { |topic| !topic.has_tags?(params[:tags]) }).page(params[:page])
        else
          @topics = paginate topics
        end
      end
    end

  end
end
