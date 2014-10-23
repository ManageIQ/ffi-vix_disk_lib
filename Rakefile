#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/ffi-vix_disk_lib'
  t.test_files = FileList['test/lib/ffi-vix_disk_lib/*_test.rb']
  t.verbose = true
end

task :default => :test
