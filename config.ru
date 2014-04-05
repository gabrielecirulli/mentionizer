$:.unshift(File.dirname(__FILE__) + "/lib")
require 'bundler/setup'

require_relative './app'
run App

