require 'rake'

desc 'Install the win32-api library (non-gem)'
task :install do
   dest = File.join(Config::CONFIG['sitelibdir'], 'win32')
   Dir.mkdir(dest) unless File.exists? dest
   cp 'lib/win32/api.rb', dest, :verbose => true
end

desc 'Build a standard gem'
task :gem do 
   spec = eval(IO.read('win32-api.gemspec'))
   Gem::Builder.new(spec).build
end

task :install_gem => [:gem] do
   file = Dir["*.gem"].first
   sh "gem install #{file}"
end

namespace :test do
  desc 'Run all tests'
  task :all do
    Dir['test/test*'].each{ |file| ruby "-Ilib #{file}" }
  end

  desc 'Run tests for the Win32::API class'
  task :core do
    ruby "-Ilib test/test_win32_api.rb"
  end

  desc 'Run tests for the Win32::API::Function class'
  task :function do
    ruby "-Ilib test/test_win32_api_function.rb"
  end

  desc 'Run tests for the Win32::API::Callback class'
  task :callback do
    ruby "-Ilib test/test_win32_api_callback.rb"
  end
end

task :test => ['test:all']
task :default => ['test:all']
