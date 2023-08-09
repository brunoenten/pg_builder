require 'rake'
require 'pg'

Given('the sql path {string}') do |sql_path|
  @sql_path = sql_path
  Rake::Task.task_defined?(@sql_path) &&
    Rake::Task[@sql_path].invoke &&
    execute_build(@pg)
end

Given('the schema {word} loaded') do |schema|
  task = "schemas:#{schema}:all"
  Rake::Task.task_defined?(task) &&
    Rake::Task[task].invoke &&
    execute_build(@pg)
end
