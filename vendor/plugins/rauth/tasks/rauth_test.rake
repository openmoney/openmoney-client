namespace(:test) do
  Rake::TestTask.new(:rauth => :test) do |t|
    t.libs << "test"
    t.pattern = "vendor/plugins/rauth/test/**/*_test.rb"
    t.verbose = true
  end
  Rake::Task['test:rauth'].comment = "Run the rauth plugin tests"
end
