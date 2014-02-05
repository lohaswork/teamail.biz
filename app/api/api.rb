module API
  class Base < Grape::API
    include APIGuard
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
      get "/personal", jbuilder: 'topics/personal.jbuilder' do
        guard!
        @topics = current_user.topics.order_by_update
      end
    end

  end
end
