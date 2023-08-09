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

After do
  @pg.close
  pg = PG.connect(dbname: 'postgres', host: '127.0.0.1', port: '45432', user: POSTGRES_USER)
  pg.exec('DROP DATABASE testdb')
  # Delete all created roles
  pg.exec("SELECT rolname FROM pg_roles WHERE rolname NOT like 'pg_%' AND rolname != '#{POSTGRES_USER}'").each do |row|
    pg.exec("DROP ROLE #{row['rolname']}")
  end
  pg.close
  Rake::Task.tasks.each(&:reenable)
end