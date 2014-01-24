module ControllerModules::Topic
  extend ActiveSupport::Concern

  included do
    helper_method :get_new_topic_participators
  end

  def get_new_topic_participators
    if session[:participators]
      session[:participators].map { |id| User.find id }
    else
      get_colleagues
    end
  end

  def add_new_topic_participators(users)
    if session[:participators]
      session[:participators] = session[:participators].concat(users.map(&:id)).uniq
    else
      session[:participators] = get_colleagues.concat(users).map(&:id)
    end
    participators = session[:participators].map { |id| User.find id }
  end

  def delete_new_topic_participators
    session[:participators] = nil
  end

end
