require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include Config

CLEAN.include(
  'lib',
  '**/*.gem',               # Gem files
  '**/*.rbc',               # Rubinius
  '**/*.o',                 # C object file
  '**/*.log',               # Ruby extension build log
  '**/Makefile',            # C Makefile
  '**/*.stackdump',         # Junk that can happen on Windows
  "**/*.#{CONFIG['DLEXT']}" # C shared object
)

make = CONFIG['host_os'] =~ /mingw|cygwin/i ? 'make' : 'nmake'

desc 'Build the ruby.exe.manifest if it does not already exist'
task :build_manifest do
  version = CONFIG['host_os'].split('_')[1]

  if version && version.to_i >= 80
    unless File.exist?(File.join(CONFIG['bindir'], 'ruby.exe.manifest'))
      Dir.chdir(CONFIG['bindir']) do
        sh "mt -inputresource:ruby.exe;2 -out:ruby.exe.manifest"
      end
    end
  end
end

desc 'Install the win32-api library (non-gem)'
task :install => [:build] do
  Dir.chdir('ext'){
    sh "#{make} install"
  }
end

desc "Build Win32::API (but don't install it)"
task :build => [:clean, :build_manifest] do
  Dir.chdir('ext') do
    ruby "extconf.rb"
    sh make
    cp "api.so", "win32" # For the test suite
  end
end

namespace 'gem' do
  desc 'Build a standard gem'
  task :create => [:clean] do
    spec = eval(IO.read('win32-api.gemspec'))
    Gem::Builder.new(spec).build
  end

  desc 'Build a binary gem'
  task :binary => [:build] do
    mkdir_p 'lib/win32'
    cp 'ext/api.so', 'lib/win32'

    spec = eval(IO.read('win32-api.gemspec'))
    spec.platform = Gem::Platform::CURRENT
    spec.extensions = nil
    spec.files = spec.files.reject{ |f| f.include?('ext') }

    Gem::Builder.new(spec).build
  end

  desc 'Install the gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install #{file}"
  end
end

namespace 'test' do
  Rake::TestTask.new(:all) do |test|
    task :all => [:build]
    test.libs << 'ext'
    test.warning = true
    test.verbose = true
  end

  Rake::TestTask.new(:callback) do |test|
    task :callback => [:build]
    test.test_files = FileList['test/test_win32_api_callback.rb']
    test.libs << 'ext'
    test.warning = true
    test.verbose = true
  end

  Rake::TestTask.new(:function) do |test|
    task :function => [:build]
    test.test_files = FileList['test/test_win32_api_function.rb']
    test.libs << 'ext'
    test.warning = true
    test.verbose = true
  end
end

task :default => 'test:all'
