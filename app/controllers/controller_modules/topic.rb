module ControllerModules::Topic
    extend ActiveSupport::Concern

  protected
    def order_by_updator(topics)
      topics.sort_by { |topic| topic.last_active_time }.reverse
    end
end
