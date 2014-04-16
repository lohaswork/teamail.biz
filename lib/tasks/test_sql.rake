namespace :benchmark do
  desc "Create Routes"
  task :test_sql => :environment do
    Benchmark.bm do |bm|
      [1000000].each do |x|
        bm.report "sql" do
          Topic.all.filter_by_tags([1,2,3,4])
        end
      end
    end

    Benchmark.bm do |bm|
      [1000000].each do |x|
        bm.report "array" do
          Topic.all.reject! { |topic| !topic.has_tags?([1,2,3,4]) }
        end
      end
    end
  end
end
