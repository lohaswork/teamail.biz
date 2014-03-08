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
        optional :tags do
          requires :id, type: Integer
        end
        requires :mailbox_type, :type => String, :desc => "MailBox type"
        requires :per_page, :type => Integer, :desc => "Page size for pagination"
        requires :page, :type => Integer, :desc => "Page number for pagination"
      end
      get "/personal", jbuilder: 'topics/personal.jbuilder' do
        guard!
        topics = paginate current_user.personal_topics(params[:mailbox_type])
        if params[:tags].present?
          @topics = topics.select { |topic| (topic.tags.map(&:id) <=> params[:tags]) != -1 }
        end
      end
    end

  end
end
