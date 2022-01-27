require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'

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
  "**/*.#{RbConfig::CONFIG['DLEXT']}", # C shared object
  "**/tmp/"
)

require 'rake/extensiontask'

spec = eval(File.read("win32-api.gemspec"))

def configure_cross_compilation(ext)
  unless RUBY_PLATFORM =~ /mswin|mingw/
    ext.cross_compile = true
    ext.cross_platform = ['x86-mingw32', 'x64-mingw32', 'x64-mingw-ucrt']
  end
end

Rake::ExtensionTask.new('win32/api', spec) do |ext|
  ext.ext_dir = 'ext/win32'
  ext.lib_dir = 'lib/win32'
  configure_cross_compilation(ext)
end

task 'gem:native' do
  sh "bundle package --all"   # Avoid repeated downloads of gems by using gem files from the host.
  %w[ x86-mingw32 x64-mingw-ucrt x64-mingw32 ].each do |plat|
    RakeCompilerDock.sh "bundle --local && rake native:#{plat} gem", platform: plat
  end
end

namespace 'test' do
  Rake::TestTask.new(:all) do |test|
    test.libs << 'test'
    test.libs << 'lib'
    test.warning = true
    test.verbose = true
  end

  Rake::TestTask.new(:callback) do |test|
    test.test_files = FileList['test/test_win32_api_callback.rb']
    test.libs << 'test'
    test.libs << 'lib'
    test.warning = true
    test.verbose = true
  end

  Rake::TestTask.new(:function) do |test|
    test.test_files = FileList['test/test_win32_api_function.rb']
    test.libs << 'ext'
    test.warning = true
    test.verbose = true
  end
end

task :default => %w(clobber compile test:all)
