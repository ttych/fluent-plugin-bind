# frozen_string_literal: true

require 'bundler'
require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs.push('lib', 'test')
  t.test_files = FileList['test/**/test_*.rb', 'test/**/*_test.rb',]
  t.verbose = false
  t.warning = false
end

task default: [:test]
