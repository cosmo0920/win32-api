########################################################################
# api.rb
#
# This is the version of win32-api for JRuby.
#
# This code was borrowed from Wayne Meissner, from the JRuby SVN trunk,
# though we have made some modifications.
########################################################################
require 'ffi'

# The Win32 module serves as a namespace only.
module Win32  

   # The API class encapsulates a function pointer to a Windows API function.
   #--
   # For the sake of FFI, the API class must be a module apparently.
   #
   class API < Module
      # The API::Error class serves as a base class for other errors.
      class Error < RuntimeError; end

      # The LoadLibraryError class is raised if a function cannot be found or loaded.
      class LoadLibraryError < Error; end

      # The PrototypeError class is raised if an invalid prototype is passed.
      class PrototypeError < Error; end
      
      # The version of the win32-api library
      VERSION = '1.5.0'
      
      private

      # :stopdoc: #
 
      SUFFIXES = ['', 'A', 'W']

      TypeDefs = {
         'V' => :void,
         'S' => :string,
         'P' => :pointer,
         'I' => :int,
         'L' => :long,
         'B' => :int      # Added this to make it work with windows-api
      }

      def self.find_prototype(name)
         TypeDefs.fetch(name){
            raise PrototypeError, "Illegal prototype '#{name}'"
         }
      end

      def self.find_return_type(name)
         TypeDefs.fetch(name){
            raise PrototypeError, "Illegal return type '#{name}'"
         }
      end

      def self.map_prototype(prototype)
         types = []

         prototype.each{ |proto|
            break if proto == 'V'
            types << self.find_prototype(proto)
         }

         types
      end

      public

      # :startdoc:

      attr_reader :function_name
      attr_reader :effective_function_name
      attr_reader :prototype
      attr_reader :return_type
      attr_reader :dll_name

      def initialize(func, proto='V', rtype='L', lib='kernel32')
         extend FFI::Library

         if proto.length > 20
            raise ArgumentError, "too many parameters: #{proto.length}"
         end

         unless proto.is_a?(Array)
            proto = proto.split('')
         end

         @function_name = func
         @prototype     = proto
         @return_type   = rtype
         @dll_name      = lib

         @effective_function_name = func

         # Re-raise a LoadError as a LoadLibraryError. This is done to
         # distinguish failure to load a Ruby library vs failure to find
         # a particular DLL.
         #
         begin
            ffi_lib lib
         rescue LoadError
            raise LoadLibraryError
         end

         ffi_convention(:stdcall)
         attached = false

         SUFFIXES.each{ |suffix|
            @effective_function_name = func.to_s + suffix

            begin
               attach_function(
                  :call,
                  @effective_function_name,
                  API.map_prototype(proto),
                  API.find_return_type(rtype)
               )
               attached = true
               break
            rescue FFI::NotFoundError
               # Do nothing yet. Raise an error later if all attempts fail.
            end
         }

         if @dll_name.match('msvc')
            msg = "Unable to load function '#{func}'"
         else
            msg = "Unable to load function '#{func}', '#{func}A', or '#{func}W'"
         end
         
         raise Error, msg if !attached
      end
   end
end
