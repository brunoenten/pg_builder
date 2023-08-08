require 'rake'
require 'pg'

Before do
  Rake::Task[:reset].invoke
  pg = PG.connect(dbname: 'postgres', host: '127.0.0.1', port: '45432', user: POSTGRES_USER)
  pg.exec('CREATE DATABASE testdb')
  pg.close
  @pg = PG.connect(dbname: 'testdb', host: '127.0.0.1', port: '45432', user: POSTGRES_USER)
  if EXTENSION_SCHEMA
    # Create schema if testing extension
    @pg.exec("CREATE SCHEMA #{EXTENSION_SCHEMA}")
  end
end

After do |_scenario|
  @pg.close
  pg = PG.connect(dbname: 'postgres', host: '127.0.0.1', port: '45432', user: POSTGRES_USER)
  pg.exec('DROP DATABASE testdb')
  pg.close
  Rake::Task.tasks.each(&:reenable)
end

Given('the sql path {string}') do |sql_path|
  @sql_path = sql_path
  Rake::Task.task_defined?(@sql_path) &&
    Rake::Task[@sql_path].invoke &&
    execute_build(@pg)
end

Then('the table {string} should exists') do |table|
  @pg.exec("SELECT 1 FROM #{table} LIMIT 1")
end
