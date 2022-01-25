##########################################################################
# extconf.rb
#
# The Windows::API binary should be built using the Rake task, i.e.
# 'rake build' or 'rake install'.
##########################################################################
require 'mkmf'

if RbConfig::CONFIG['host_os'] =~ /mingw/
  $CFLAGS << ' -fno-omit-frame-pointer'
end

have_func('strncpy_s')

create_makefile('win32/api')
