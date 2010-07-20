############################################################################
# test_win32_api.rb
# 
# Test case for the Win32::API class. You should run this as Rake task,
# i.e. 'rake test', instead of running it directly.
############################################################################
require 'rubygems'
gem 'test-unit'

require 'win32/api'
require 'test/unit'
include Win32

class TC_Win32_API < Test::Unit::TestCase
  def setup
    @buf = 0.chr * 260
    @gfa = API.new('GetFileAttributes', 'S', 'L')
    @gcd = API.new('GetCurrentDirectory', 'LP')
    @gle = API.new('GetLastError', 'V', 'L')
    @str = API.new('strstr', 'PP', 'P', 'msvcrt')
  end

  test 'version number is up to date' do
    assert_equal('1.5.0', API::VERSION)
  end

  test 'constructor accepts only argument' do
    assert_nothing_raised{ API.new('GetCurrentDirectory') }
  end

  test 'constructor accepts an explicit function prototype' do
    assert_nothing_raised{ API.new('GetCurrentDirectory', 'LP') }
  end

  test 'constructor accepts an explicit return type' do
    assert_nothing_raised{ API.new('GetCurrentDirectory', 'LP', 'L') }
  end

  test 'constructor accepts an explicit dll name' do
    assert_nothing_raised{ API.new('GetCurrentDirectory', 'LP', 'L', 'kernel32') }
  end
 
  test 'call method is defined and can be called explicitly' do
    assert_respond_to(@gcd, :call)
    assert_nothing_raised{ @gcd.call(@buf.length, @buf) }
    assert_equal(Dir.pwd.tr('/', "\\"), @buf.strip)
  end
   
  test 'a method with a void prototype may be called with or without an explicit nil' do
    assert_nothing_raised{ @gle.call }
    assert_nothing_raised{ @gle.call(nil) }
  end

  test 'call method returns a value on failure' do
    assert_equal(0xFFFFFFFF, @gfa.call('C:/foobarbazblah'))
  end
   
  test 'dll_name basic functionality' do
    assert_respond_to(@gcd, :dll_name)
    assert_equal('kernel32', @gcd.dll_name)
  end
   
  test 'function_name basic funcitonality' do
    assert_respond_to(@gcd, :function_name)
    assert_equal('GetCurrentDirectory', @gcd.function_name)
    assert_equal('strstr', @str.function_name)
  end
   
  test 'effective_function_name basic funcitonality' do
    assert_respond_to(@gcd, :effective_function_name)
    assert_equal('GetCurrentDirectoryA', @gcd.effective_function_name)
    assert_equal('strstr', @str.effective_function_name)
  end

  test 'effective_function_name returns expected ANSI function name' do
    @gcd = API.new('GetCurrentDirectoryA', 'LP')
    assert_equal('GetCurrentDirectoryA', @gcd.effective_function_name)
  end

  test 'effective_function_name returns expected wide function name' do
    @gcd = API.new('GetCurrentDirectoryW', 'LP')
    assert_equal('GetCurrentDirectoryW', @gcd.effective_function_name)
  end
   
  test 'prototype basic functionality' do
    assert_respond_to(@gcd, :prototype)
    assert_equal(['L', 'P'], @gcd.prototype)
  end
   
  test 'return_type basic functionality' do
    assert_respond_to(@gcd, :return_type)
    assert_equal('L', @gcd.return_type)
  end
   
  test 'high iteration testing for constructor' do
    assert_nothing_raised{
      1000.times{ API.new('GetUserName', 'P', 'P', 'advapi32') }
    }
  end
   
  test 'constructor requires at least one argument' do
    assert_raise(ArgumentError){ API.new }
  end

  test 'maximum prototype size is 20 characters' do
    assert_raise(ArgumentError){ API.new('GetUserName', ('L' * 21), 'X') }
  end

  test 'an error is raised if the function is not found' do
    assert_raise(API::LoadLibraryError){ API.new('NoSuchFunction', 'PL', 'I') }
  end

  test 'an error is raised if the function cannot be found in the dll specified' do
    assert_raise(API::LoadLibraryError){ API.new('GetUserName', 'PL', 'I', 'foo') }
  end

  test 'an error is raised if an invalid prototype is used' do
    assert_raise(API::PrototypeError){ API.new('GetUserName', 'X', 'I', 'advapi32') }
  end

  test 'an error is raised if an invalid return type is used' do
    assert_raise(API::PrototypeError){ API.new('GetUserName', 'PL', 'X', 'advapi32') }
  end

  test 'expected error messages for invalid constructor calls' do
    assert_raise_message("Unable to load function 'Zap', 'ZapA', or 'ZapW'"){
      API.new('Zap')
    }

    assert_raise_message("Unable to load function 'strxxx'"){
      API.new('strxxx', 'P', 'L', 'msvcrt')
    }

    assert_raise_message("Illegal prototype 'X'"){
      API.new('GetUserName', 'X', 'I', 'advapi32')
    }

    assert_raise_message("Illegal return type 'Y'"){
      API.new('GetUserName', 'PL', 'Y', 'advapi32')
    }
  end

  test 'a type error is raised if an argument type does not match the prototype' do
    assert_raise(TypeError){ @gcd.call('test', @buf) }
  end

  test 'various error classes are declared' do
    assert_not_nil(Win32::API::Error)
    assert_not_nil(Win32::API::LoadLibraryError)
    assert_not_nil(Win32::API::PrototypeError)
  end

  test 'error class parent types' do
    assert_kind_of(RuntimeError, Win32::API::Error.new)
    assert_kind_of(Win32::API::Error, Win32::API::LoadLibraryError.new)
    assert_kind_of(Win32::API::Error, Win32::API::PrototypeError.new)
  end

  def teardown
    @buf = nil
    @gcd = nil
    @gle = nil
    @str = nil
  end
end
