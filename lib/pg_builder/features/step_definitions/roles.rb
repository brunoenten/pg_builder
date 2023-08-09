Given('a basic role {word}') do |role|
  @pg.exec("CREATE ROLE #{role}")
end

Given('current user is {word}') do |role|
  @pg.exec("SET ROLE #{role}")
end

Given('role {word} has usage of schema {word}') do |role, schema|
  @pg.exec("GRANT USAGE ON SCHEMA #{schema} TO #{role}")
end