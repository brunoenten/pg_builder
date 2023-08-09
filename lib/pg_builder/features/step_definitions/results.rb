Then('result should be {string}') do |result_value|
  expect(@result.getvalue(0,0)).to eq(result_value)
end