#!/usr/bin/env rake

require 'rspec/core/rake_task'
require File.expand_path('../config/application', __FILE__)

RSpec::Core::RakeTask.new :spec

task default: :spec

Blog::Application.load_tasks
