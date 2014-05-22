$:.unshift(File.dirname(__FILE__) + "/lib")
require 'bundler/setup'

# disable buffering to have log messages sent straight to Logplex
$stdout.sync = true

require_relative './app'
run App

