  # encoding: utf-8
module EmailEngine
  module EmailReciver

    class Email
      def initialize(hash={})
        hash.each do |k, v|
          k = k.underscore
          self.define_singleton_method(k) do
            self.instance_variable_get("@#{k}")
          end
          self.define_singleton_method("#{k}=".to_sym) do |value|
            self.instance_variable_set("@#{k}", value)
          end
          self.send "#{k}=", v
        end
      end
    end

  end
end
