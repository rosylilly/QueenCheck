guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  watch(/^.+\.gemspec/)
end

spork_port = RUBY_VERSION >= '1.9.2' ? 8989 : 8988
guard 'spork', :cucumber => false, :bundler => false, :rspec_port => spork_port do
end

guard 'rspec', :version => 2, :cli => "--drb --drb-port #{spork_port} --color --format Fuubar" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard 'yard', :plugin => 'yard-tomdoc' do
  watch(%r{lib/.+\.rb})
end

