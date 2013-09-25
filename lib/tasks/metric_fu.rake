begin
  require 'metric_fu'

  MetricFu::Configuration.run do |config|
    config.metrics = [:rails_best_practices]
    config.reek = { :dirs_to_reek => ['app/models', 'app/helpers', 'lib'] }
  end

rescue LoadError
end
