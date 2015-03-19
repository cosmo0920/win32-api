require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include RbConfig

CLEAN.include(
  '**/*.gem',               # Gem files
  '**/*.rbc',               # Rubinius
  '**/*.o',                 # C object file
  '**/*.log',               # Ruby extension build log
  '**/Makefile',            # C Makefile
  '**/*.def',               # Definition files
  '**/*.exp',
  '**/*.lib',
  '**/*.pdb',
  '**/*.obj',
  '**/*.stackdump',         # Junk that can happen on Windows
  "**/*.#{CONFIG['DLEXT']}" # C shared object
)

CLOBBER.include('lib') # Generated when building binaries

make = CONFIG['host_os'] =~ /mingw|cygwin/i ? 'make' : 'nmake'

desc 'Build the ruby.exe.manifest if it does not already exist'
task :build_manifest do
  version = CONFIG['host_os'].split('_')[1]

  if version && version.to_i >= 80
    unless File.exist?(File.join(CONFIG['bindir'], 'ruby.exe.manifest'))
      Dir.chdir(CONFIG['bindir']) do
        sh "mt -nologo -inputresource:ruby.exe;2 -out:ruby.exe.manifest"
      end
    end
  end
end

desc "Build the win32-api library"
task :build => [:clean, :build_manifest] do
  require 'devkit' if RbConfig::CONFIG['host_os'] =~ /mingw|cygwn/i
  Dir.chdir('ext') do
    ruby "extconf.rb"
    sh make
    cp 'api.so', 'win32' # For testing
  end
end

namespace 'gem' do
  require 'rubygems/package'

  desc 'Build the win32-api gem'
  task :create => [:clean] do
    spec = eval(IO.read('win32-api.gemspec'))
    if Gem::VERSION.to_f < 2.0
      Gem::Builder.new(spec).build
    else
      Gem::Package.build(spec)
    end
  end

  desc 'Build a binary gem'
  task :binary, :ruby18, :ruby19, :ruby2_32, :ruby2_64, :ruby21, :ruby21_64, :ruby22, :ruby22_64 do |task, args|
    require 'devkit' if RbConfig::CONFIG['host_os'] =~ /mingw|cygwn/i

    # These are just what's on my system at the moment. Adjust as needed.
    args.with_defaults(
      :ruby18    => "c:/ruby187/bin/ruby",
      :ruby19    => "c:/ruby193/bin/ruby",
      :ruby2_32  => "c:/ruby2/bin/ruby",
      :ruby2_64  => "c:/ruby264/bin/ruby",
      :ruby21_32 => "c:/ruby21/bin/ruby",
      :ruby21_64 => "c:/ruby21-x64/bin/ruby",
      :ruby22_32 => "c:/ruby22/bin/ruby",
      :ruby22_64 => "c:/ruby22-x64/bin/ruby"
    )

    Rake::Task[:clobber].invoke

    args.each{ |key, rubyx|
      # Adjust devkit paths as needed.
      if `"#{rubyx}" -v` =~ /x64/i
        ENV['PATH'] = "C:/Devkit64/bin;C:/Devkit64/mingw/bin;" + ENV['PATH']
      else
        ENV['PATH'] = "C:/Devkit/bin;C:/Devkit/mingw/bin;" + ENV['PATH']
      end

      mkdir_p "lib/win32/#{key}/win32"

      Dir.chdir('ext') do
        sh "make distclean" rescue nil
        sh "#{rubyx} extconf.rb"
        sh "make"
        cp 'api.so', "../lib/win32/#{key}/win32/api.so"
      end
    }

text = <<HERE
require 'rbconfig'

case RbConfig::CONFIG['MAJOR']
  when '1'
    if RbConfig::CONFIG['MINOR'] == '8'
      require File.join(File.dirname(__FILE__), 'ruby18/win32/api')
    else
      require File.join(File.dirname(__FILE__), 'ruby19/win32/api')
    end
  when '2'
    if RbConfig::CONFIG['MINOR'] == '0'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby2_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby2_32/win32/api')
      end
    end

    if RbConfig::CONFIG['MINOR'] == '1'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby21_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby21_32/win32/api')
      end
    end

    if RbConfig::CONFIG['MINOR'] == '2'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby22_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby22_32/win32/api')
      end
    end
end
HERE

    File.open('lib/win32/api.rb', 'w'){ |fh| fh.puts text }
      
    spec = eval(IO.read('win32-api.gemspec'))
    spec.platform = Gem::Platform.new(['universal', 'mingw32'])
    spec.extensions = nil
    spec.files = spec.files.reject{ |f| f.include?('ext') }

    if Gem::VERSION.to_f < 2.0
      Gem::Builder.new(spec).build
    else
      require 'rubygems/package'
      Gem::Package.build(spec)
    end
  end

  desc 'Install the gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
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
