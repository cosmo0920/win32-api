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
  task :binary, :ruby2_32, :ruby2_64, :ruby21, :ruby21_64, :ruby22, :ruby22_64, :ruby23_32, :ruby23_64, :ruby24_32, :ruby24_64, :ruby25_32, :ruby25_64, :ruby_26_32, :ruby26_64, :ruby27_32, :ruby27_64, :ruby30_32, :ruby30_64, :ruby31_32, :ruby31_64 do |task, args|
    # These are just what's on my system at the moment. Adjust as needed.
    # ri refers to RubyInstaller, ruby 2.3 and prev were built with RubyInstaller (:ri),
    # 2.4 and later with RubyInstaller2 (:ri2)
    # pre variable allows local builds with ruby & DevKit not at drive root

    dk_path = {}
    if ENV['APPVEYOR'] =~ /true/i
      pre = "C:"
      dk_path[:ri]    = "C:/ruby23/DevKit/bin;C:/ruby23/DevKit/mingw/bin"
      dk_path[:ri_64] = "C:/ruby23-x64/DevKit/bin;C:/ruby23-x64/DevKit/mingw/bin"
    else
      ENV['BASEPATH'] = ENV['PATH'].gsub(/\\/, '/')
      pre = "C:"
      dk_path[:ri]    = "#{pre}/Devkit/bin;#{pre}/Devkit/mingw/bin"
      dk_path[:ri_64] = "#{pre}/Devkit64/bin;#{pre}/Devkit64/mingw/bin"
    end
    # at present, Appveyor & local DevKit paths match for ri2
    dk_path[:ri2]    = "C:/msys64/usr/bin;C:/msys64/mingw32/bin"
    dk_path[:ri2_64] = "C:/msys64/usr/bin;C:/msys64/mingw64/bin"

    args.with_defaults(
      {
        :ruby2_32  => {:path => "#{pre}/ruby200/bin",     :ri => :ri,     :omit => false},
        :ruby2_64  => {:path => "#{pre}/ruby200-x64/bin", :ri => :ri_64,  :omit => false},
        :ruby21_32 => {:path => "#{pre}/ruby21/bin",      :ri => :ri,     :omit => false},
        :ruby21_64 => {:path => "#{pre}/ruby21-x64/bin",  :ri => :ri_64,  :omit => false},
        :ruby22_32 => {:path => "#{pre}/ruby22/bin",      :ri => :ri,     :omit => false},
        :ruby22_64 => {:path => "#{pre}/ruby22-x64/bin",  :ri => :ri_64,  :omit => false},
        :ruby23_32 => {:path => "#{pre}/ruby23/bin",      :ri => :ri,     :omit => false},
        :ruby23_64 => {:path => "#{pre}/ruby23-x64/bin",  :ri => :ri_64,  :omit => false},
        :ruby24_32 => {:path => "#{pre}/ruby24/bin",      :ri => :ri2,    :omit => false},
        :ruby24_64 => {:path => "#{pre}/ruby24-x64/bin",  :ri => :ri2_64, :omit => false},
        :ruby25_32 => {:path => "#{pre}/ruby25/bin",      :ri => :ri2,    :omit => false},
        :ruby25_64 => {:path => "#{pre}/ruby25-x64/bin",  :ri => :ri2_64, :omit => false},
        :ruby26_32 => {:path => "#{pre}/ruby26/bin",      :ri => :ri2,    :omit => false},
        :ruby26_64 => {:path => "#{pre}/ruby26-x64/bin",  :ri => :ri2_64, :omit => false},
        :ruby27_32 => {:path => "#{pre}/ruby27/bin",      :ri => :ri2,    :omit => true},
        :ruby27_64 => {:path => "#{pre}/ruby27-x64/bin",  :ri => :ri2_64, :omit => true},
        :ruby30_32 => {:path => "#{pre}/ruby30/bin",      :ri => :ri2,    :omit => true},
        :ruby30_64 => {:path => "#{pre}/ruby30-x64/bin",  :ri => :ri2_64, :omit => true},
        :ruby31_32 => {:path => "#{pre}/ruby31/bin",      :ri => :ri2,    :omit => true},
        :ruby31_64 => {:path => "#{pre}/ruby31-x64/bin",  :ri => :ri2_64, :omit => true},
      }
    )

    Rake::Task[:clobber].invoke

    default_path = ENV['PATH']

    args.each { |key|
      # These lines are used for trunk build.
      if key.last[:omit] && !File.exist?("#{key.last[:path]}/ruby.exe")
        puts "#{key.last[:path]}/ruby does not exist! Skip."
        next
      end

      bld_path = "#{key.last[:path]};#{dk_path[key.last[:ri]]};#{ENV['BASEPATH']}"
      mkdir_p "lib/win32/#{key.first}/win32"

      Dir.chdir('ext') do
        ENV['PATH'] = bld_path
        sh "make distclean" rescue nil
        sh "ruby extconf.rb"
        sh "make"
        sh "strip --strip-unneeded -p api.so"
        ENV['PATH'] = default_path
        cp 'api.so', "../lib/win32/#{key.first}/win32/api.so"
      end
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

    if RbConfig::CONFIG['MINOR'] == '6'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby26_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby26_32/win32/api')
      end
    end

    if RbConfig::CONFIG['MINOR'] == '7'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby27_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby27_32/win32/api')
      end
    end
  when '3'
    if RbConfig::CONFIG['MINOR'] == '0'
      if RbConfig::CONFIG['arch'] =~ /x64/i
        require File.join(File.dirname(__FILE__), 'ruby30_64/win32/api')
      else
        require File.join(File.dirname(__FILE__), 'ruby30_32/win32/api')
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
