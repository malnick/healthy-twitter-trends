#!/bin/env ruby

require 'rubygems'
require 'json'
require 'twitter'
require 'optparse'
require 'logger'

library_files = Dir[File.join(File.dirname(__FILE__), "/health/**/*.rb")].sort
library_files.each do |file|
  require file
end

#Health::Server.new
