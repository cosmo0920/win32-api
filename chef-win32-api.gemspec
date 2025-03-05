require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'chef-win32-api'
  spec.version    = '1.11.0'
  spec.authors    = ['Daniel J. Berger', 'Park Heesob', 'Hiroshi Hatake']
  spec.license    = 'Artistic-2.0'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'http://github.com/cosmo0920/win32-api'
  spec.summary    = 'A superior replacement for Win32API'
  spec.test_files = Dir['test/test*']
  spec.extensions = ['ext/win32/extconf.rb']
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }

  if RUBY_VERSION.match? /(3.0.\d)/
    spec.required_ruby_version = '>= 3.0.0'
  else
    spec.required_ruby_version = '>= 3.1.6'
  end

  spec.extra_rdoc_files = ['CHANGES', 'MANIFEST', 'ext/win32/api.c']

  spec.add_development_dependency('test-unit', '>= 3.6.7')
  spec.add_development_dependency('rake')
  spec.add_development_dependency("rake-compiler", ">= 1.2.9")

  spec.description = <<-EOF
    The Win32::API library is meant as a replacement for the Win32API
    library that ships as part of the standard library. It contains several
    advantages over Win32API, including callback support, raw function
    pointers, an additional string type, and more.
  EOF
end
