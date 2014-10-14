#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/ffi-vixdisklib'
  t.test_files = FileList['test/lib/ffi-vixdisklib/*_test.rb']
  t.verbose = true
end

task :default => :test
