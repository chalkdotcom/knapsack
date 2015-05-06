require 'knapsack'

begin
  require 'rspec/core/rake_task'
  require 'ci/reporter/rake/rspec'
  namespace :knapsack do
    task :rspec, [:rspec_args] => 'ci:setup:rspec' do |_, args|
      allocator = Knapsack::AllocatorBuilder.new(Knapsack::Adapters::RspecAdapter).allocator

      puts
      puts 'Report specs:'
      puts allocator.report_node_tests
      puts
      puts 'Leftover specs:'
      puts allocator.leftover_node_tests
      puts

      RSpec::Core::RakeTask.new(:rspec) do |t|
        t.pattern = allocator.stringify_node_tests.split(' ').join(',')
        t.rspec_opts = args[:rspec_args]
      end
      Rake::Task['rspec'].execute
    end
  end
rescue LoadError
end
