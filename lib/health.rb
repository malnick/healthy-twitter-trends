#!/bin/env ruby

require 'rubygems'
require 'json'
require 'twitter'
require 'optparse'

library_files = Dir[File.join(File.dirname(__FILE__), "/health/**/*.rb")].sort
library_files.each do |file|
  require file
end

#module Health
#	@options ||= Options.new
#	  class << self
#	    attr_accessor :options
#	  end
#
#	  class Exception < ::Exception
#	  end
#end
