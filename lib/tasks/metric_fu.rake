begin
  require 'metric_fu'

  MetricFu::Configuration.run do |config|
    config.reek = { :dirs_to_reek => ['app/model', 'app/helper', 'lib'] }
  end

rescue LoadError
end
