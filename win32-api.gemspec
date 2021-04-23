require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'win32-api'
  spec.version    = '1.10.1'
  spec.authors    = ['Daniel J. Berger', 'Park Heesob', 'Hiroshi Hatake']
  spec.license    = 'Artistic-2.0'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'http://github.com/cosmo0920/win32-api'
  spec.summary    = 'A superior replacement for Win32API'
  spec.test_files = Dir['test/test*']
  spec.extensions = ['ext/extconf.rb']
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }

  spec.required_ruby_version = '>= 1.8.2'
  spec.extra_rdoc_files = ['CHANGES', 'MANIFEST', 'ext/win32/api.c']

  spec.add_development_dependency('test-unit', '>= 2.5.0')
  spec.add_development_dependency('rake')

  spec.description = <<-EOF
    The Win32::API library is meant as a replacement for the Win32API
    library that ships as part of the standard library. It contains several
    advantages over Win32API, including callback support, raw function
    pointers, an additional string type, and more.
  EOF
end
