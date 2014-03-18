module API
  class Base < Grape::API
    include APIGuard
    include Grape::Kaminari
    version "#{$config.api_version}", using: :path
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      Rack::Response.new({
        errors: "Bad Request",
        error_description: e.message
      }.to_json, 400, { "Content-Type" => "application/json" })
    end

    helpers do
      def current_user
        @current_user ||= OauthAccessToken.find_by(:token, params[:access_token]).user
      end

      def current_organization
        begin
          @current_organization ||= ::Organization.for_user(@current_user).find(@current_user.default_organization_id)
        rescue
          nil
        end
      end
    end

    resources :topics do
      desc "Return current user personal topics."

      params do
        requires :per_page, :type => Integer, :desc => "Page size for pagination"
        requires :page, :type => Integer, :desc => "Page number for pagination"
      end
      get "/personal", jbuilder: 'topics/topic_list.jbuilder' do
        guard!
        params do
          requires :mailbox_type, :type => String, :desc => "MailBox type"
        end
        topics = current_user.personal_topics(params[:mailbox_type])
        @topics = paginate topics
        @total_count = topics.size
      end

      get "/organization", jbuilder: 'topics/topic_list.jbuilder' do
        guard!
        params do
          optional :tags, :type => Array, :desc => "Tag IDs for filter"
        end
        topics = current_organization.topics.order_by_update
        if params[:tags].present?
          # TODO: 1. want to change has_tag filter by sql
          #       2. the personal.jbuilder and organization.builder are same now, we should reuse the code if they has no difference later
          @topics = Kaminari.paginate_array(topics.reject! { |topic| !topic.has_tags?(params[:tags]) }).page(params[:page]).per(params[:per_page])
        else
          @topics = paginate topics
        end
        @total_count = topics.size
      end
    end

    #Handle 404 error in scope /api/v1
    route :any, '*path' do
      error!("No such route", 404)
    end

  end
end
