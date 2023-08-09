Then('the table {string} should exists') do |table|
  @pg.exec("SELECT 1 FROM #{table} LIMIT 1")
end