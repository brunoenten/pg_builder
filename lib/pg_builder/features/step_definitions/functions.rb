Then('the function {string} should exists') do |function|
  @pg.exec("SELECT '#{function}'::regproc")
end

When('calling function {word} with arguments \({}\)') do |function_name, args|
  @result = @pg.exec("SELECT #{function_name}(#{args})")
end