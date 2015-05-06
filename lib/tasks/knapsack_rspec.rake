require 'knapsack'

begin
  require 'rspec/core/rake_task'
  require 'ci/reporter/rake/rspec'

  namespace :knapsack do
    RSpec::Core::RakeTask.new(:rspec_run) do |t|
      t.test_files = ENV['KNAPSACK_RSPEC_TEST_FILES'].to_s.split(' ')
    end

    task :rspec, [:rspec_args] => 'ci:setup:rspec' do |_, args|
      allocator = Knapsack::AllocatorBuilder.new(Knapsack::Adapters::RspecAdapter).allocator

      puts
      puts 'Report specs:'
      puts allocator.report_node_tests
      puts
      puts 'Leftover specs:'
      puts allocator.leftover_node_tests
      puts

      cmd = %Q[KNAPSACK_RSPEC_TEST_FILES="#{allocator.stringify_node_tests}" bundle exec rake knapsack:rspec_run]
      system(cmd)
      exit($?.exitstatus)
    end
  end
rescue LoadError
end
