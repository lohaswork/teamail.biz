module API
  class Base < Grape::API
    include APIGuard
    version 'v1', using: :path
    format :json

    guard_all!

    resource :topic do

      get "/" do
        Topic.first
      end
    end



  end
end
