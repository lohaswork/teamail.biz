module ControllerModules::Topic
    extend ActiveSupport::Concern

  included do
    helper_method :order_by_updator
  end

  protected
    def order_by_updator(topics)
      topics.sort_by { |topic| topic.last_active_time }.reverse
    end
end
