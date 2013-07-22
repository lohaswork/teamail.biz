begin
  require 'metric_fu'

  MetricFu::Configuration.run do |config|
    config.metrics -= [:cane]
    config.reek = { :dirs_to_reek => ['app/models', 'app/helpers', 'lib'] }
  end

rescue LoadError
end
