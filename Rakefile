namespace :test do
  namespace :rspec do
    desc "Run the tests for the Calculator example in the Rspec tutorial"
    task :calculator do
      exec 'bundle exec rspec fundamentals/rspec/calculator/max_spec.rb'
    end

    desc "Run the tests for the Subscription example in the Rspec tutorial"
    task :subscription do
      exec 'bundle exec rspec fundamentals/rspec/subscription/subscription_spec.rb'
    end
  end

  namespace :approach do
    desc "Run the tests for the Bowling example in the approach tutorial"
    task :bowling do
      exec 'bundle exec rspec fundamentals/approach/bowling/*_spec.rb'
    end
  end
end
