require 'simplecov'

require 'pp'
require_relative 'support/shared_examples'

RSpec.configure do |c|
  c.expect_with :rspec do |c|
    c.syntax = :expect
  end
  c.inclusion_filter = { :focus => true }
  c.exclusion_filter = { :disabled => true }
  c.run_all_when_everything_filtered = true
  c.fail_fast = true
  c.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end

Thread.abort_on_exception = true

SimpleCov.start do
  add_filter do |source_file|
    source_file.lines.count < 10
  end
  add_filter 'spec'
end

Dir.chdir('spec') do
  Dir['support/**/*.rb'].reverse.each do |file|
    require file
  end
end
