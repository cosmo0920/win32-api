begin
  m = /(\d+.\d+)/.match(RUBY_VERSION)
  ver = m[1]
  require "win32/#{ver}/api.so"
rescue LoadError
  require "win32/api.so"
end
