# Description
  This is a drop-in replacement for the Win32API library currently part of
  Ruby's standard library.

# Synopsis

```ruby
  require 'win32/api'
  include Win32

  # Typical example - Get user name
  buf = 0.chr * 260
  len = [buf.length].pack('L')

  GetUserName = API.new('GetUserName', 'PP', 'I', 'advapi32')
  GetUserName.call(buf, len)

  puts buf.strip

  # Callback example - Enumerate windows
  EnumWindows     = API.new('EnumWindows', 'KP', 'L', 'user32')
  GetWindowText   = API.new('GetWindowText', 'LPI', 'I', 'user32')
  EnumWindowsProc = API::Callback.new('LP', 'I'){ |handle, param|
    buf = "\0" * 200
    GetWindowText.call(handle, buf, 200);
    puts buf.strip unless buf.strip.empty?
    buf.index(param).nil? ? true : false
  }

  EnumWindows.call(EnumWindowsProc, 'UEDIT32')

  # Raw function pointer example - System beep
  LoadLibrary    = API.new('LoadLibrary', 'P', 'L')
  GetProcAddress = API.new('GetProcAddress', 'LP', 'L')

  hlib = LoadLibrary.call('user32')
  addr = GetProcAddress.call(hlib, 'MessageBeep')
  func = Win32::API::Function.new(addr, 'L', 'L')
  func.call(0)
```

# Differences between win32-api and Win32API
  * This library has callback support
  * This library supports raw function pointers.
  * This library supports a separate string type for const char* (S).
  * Argument order change. The DLL name is now last, not first.
  * Removed the 'N' and 'n' prototypes. Always use 'L' for longs now.
  * Sensible default arguments for the prototype, return type and DLL name.
  * Reader methods for the function name, effective function name, prototype,
    return type and DLL.
  * Removed the support for lower case prototype and return types. Always
    use capital letters.

# Developer's Notes
  NOTE: **Some of the information below is now out of date, but explains my
  motivation at the time the project was originally created.**

  The current Win32API library that ships with the standard library has been
  slated for removal from Ruby 2.0 and it will not receive any updates in the
  Ruby 1.8.x branch. I have far too many libraries invested in it to let it
  die at this point.

  In addition, the current Win32API library was written in the bad old Ruby
  1.6.x days, which means it doesn't use the newer allocation framework.
  There were several other refactorings that I felt it needed to more closely
  match how it was actually being used in practice.

  The first order of business was changing the order of the arguments. By
  moving the DLL name from first to last, I was able to provide reasonable
  default arguments for the prototype, return type and the DLL. Only the
  function name is required now.

  There was a laundry list of other refactorings that were needed: sensical
  instance variable names with proper accessors, removing support for lower
  case prototype and return value characters that no one used in practice,
  better naming conventions, the addition of RDoc ready comments and,
  especially, callback and raw function pointer support.

  Most importantly, we can now add, modify and fix any features that we feel
  best benefit our end users.

# Multiple Binaries
  As of win32-api 1.4.8 a binary gem is shipped that contains binaries for
  both Ruby 1.8, Ruby 1.9, and 2.x. For Ruby 2.x, both 32 and 64 bit binaries
  are included as of release 1.5.0.

  The file under lib/win32 dynamically requires the correct binary based on
  your version of Ruby.

# Documentation
  The source file contains inline RDoc documentation. If you installed
  this file as a gem, then you have the docs. Run "gem server" and point
  your browser at http://localhost:8808 to see them.

# Warranty
  This package is provided "as is" and without any express or
  implied warranties, including, without limitation, the implied
  warranties of merchantability and fitness for a particular purpose.

# Known Issues
  Possible callback issues when dealing with multi-threaded applications.

  Please submit any bug reports to the project page at
  https://github.com/cosmo0920/win32-api

## Contributions
  Although this library is free, please consider having your company
  setup a gittip if used by your company professionally.

  http://www.gittip.com/djberg96/

# Future Plans
  I really don't have future plans for this library since you should use FFI
  as your preferred C interface going forward. All of my own projects have
  since been converted to either use FFI or an analogous OLE interface.

  I will continue to maintain this library as long as there are folks out
  there who are still using it, but I strongly encourage you to convert
  your projects to FFI when possible.

# Copyright
  (C) 2003-2015 Daniel J. Berger

  (C) 2016-2020 Hiroshi Hatake

  All Rights Reserved

# License
  Artistic 2.0

# Authors
  Daniel J. Berger

  Park Heesob

  Hiroshi Hatake
