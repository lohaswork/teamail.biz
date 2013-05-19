class AppConfig
  def initialize(config_file="#{Rails.root}/config/config.rb")
    hash=eval(File.read config_file)
    @config = Config.new(( hash[:default] || {}).deep_merge(hash[Rails.env.to_sym] || {}) )
  end

  class Config
    def initialize(hash)
      hash.each do |k, v|
        self.define_singleton_method(k) do
          self.instance_variable_get("@#{k}")
        end
        self.define_singleton_method("#{k}=".to_sym) do |value|
          self.instance_variable_set("@#{k}", value)
        end
        if v && v.is_a?(Hash)
          v = AppConfig::Config.new(v)
        end
        self.send "#{k}=", v
      end
    end
  end

  def method_missing(meth, *args, &block)
    @config.send(meth, *args, &block)
  end
end
