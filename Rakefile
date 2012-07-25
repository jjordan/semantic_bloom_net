#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'pathname'
require 'rubygems'
require 'rake'

BASEDIR = Pathname.new( __FILE__ ).expand_path.dirname
# we want the root of the project to be in the include path
$:.unshift( BASEDIR.to_s )
# we also want the lib/ dir to be in the include path
$:.unshift( (BASEDIR + 'lib').to_s )
TASKSDIR = BASEDIR + 'tasks'

require TASKSDIR + 'rake_helpers'

require_all Pathname.glob( (TASKSDIR + '*.rb').to_s ), :Task 


