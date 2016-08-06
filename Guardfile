guard :rspec, cmd: 'bundle exec rspec --format documentation' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/music-theory/(.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')          { "spec" }
end
