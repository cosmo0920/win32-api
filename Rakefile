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
  task :binary, :ruby2_32, :ruby2_64, :ruby21, :ruby21_64, :ruby22, :ruby22_64, :ruby23_32, :ruby23_64, :ruby24_32, :ruby24_64 do |task, args|
    # These are just what's on my system at the moment. Adjust as needed.
    args.with_defaults(
      {
        :ruby2_32  => {:path => "c:/ruby200/bin/ruby",     :msys => :msys1},
        :ruby2_64  => {:path => "c:/ruby200-x64/bin/ruby", :msys => :msys1},
        :ruby21_32 => {:path => "c:/ruby21/bin/ruby",      :msys => :msys1},
        :ruby21_64 => {:path => "c:/ruby21-x64/bin/ruby",  :msys => :msys1},
        :ruby22_32 => {:path => "c:/ruby22/bin/ruby",      :msys => :msys1},
        :ruby22_64 => {:path => "c:/ruby22-x64/bin/ruby",  :msys => :msys1},
        :ruby23_32 => {:path => "c:/ruby23/bin/ruby",      :msys => :msys1},
        :ruby23_64 => {:path => "c:/ruby23-x64/bin/ruby",  :msys => :msys1},
        :ruby24_32 => {:path => "c:/ruby24/bin/ruby",      :msys => :msys2},
        :ruby24_64 => {:path => "c:/ruby24-x64/bin/ruby",  :msys => :msys2},
        :ruby25_32 => {:path => "c:/ruby25/bin/ruby",      :msys => :msys2},
        :ruby25_64 => {:path => "c:/ruby25-x64/bin/ruby",  :msys => :msys2}
      }
    )

    Rake::Task[:clobber].invoke

    args.each{ |key|
      default_path = ENV['PATH']

      spec = eval(IO.read('win32-api.gemspec'))

      if spec.version.prerelease? && !File.exist?("#{key.last[:path]}.exe")
        puts "#{key.last[:path]} does not exist! Skip."
        next
      end

      if key.last[:msys] == :msys1
        # Adjust devkit paths as needed.
        if `"#{key.last[:path]}" -v` =~ /x64/i
          ENV['PATH'] = "C:/Devkit64/bin;C:/Devkit64/mingw/bin;" + ENV['PATH']
        else
          ENV['PATH'] = "C:/Devkit/bin;C:/Devkit/mingw/bin;" + ENV['PATH']
        end
      elsif key.last[:msys] == :msys2
        ENV.delete('RI_DEVKIT')
        # Adjust devkit paths as needed.
        if `"#{key.last[:path]}" -v` =~ /x64/i
          ENV['PATH'] = "C:/msys64/usr/bin;C:/msys64/mingw64/bin;" + ENV['PATH']
        else
          ENV['PATH'] = "C:/msys64/usr/bin;C:/msys64/mingw32/bin;" + ENV['PATH']
        end
      end
      mkdir_p "lib/win32/#{key.first}/win32"

      Dir.chdir('ext') do
        sh "make distclean" rescue nil
        sh "#{key.last[:path]} extconf.rb"
        sh "make"
        cp 'api.so', "../lib/win32/#{key.first}/win32/api.so"
      end

      ENV['PATH'] = default_path
    }

text = <<HERE
require 'rbconfig'
begin
  case RbConfig::CONFIG['MAJOR']
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

    if RbConfig::CONFIG['MINOR'] == '3'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby23_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby23_32/win32/api')
      end
    end

    if RbConfig::CONFIG['MINOR'] == '4'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby24_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby24_32/win32/api')
      end
    end

    if RbConfig::CONFIG['MINOR'] == '5'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby25_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby25_32/win32/api')
      end
    end

  end
rescue LoadError
  require File.join(File.dirname(__FILE__), '../../ext/api')
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
