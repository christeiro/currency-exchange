Fabricator(:currency) do
  code { Money::Currency.new('EUR').iso_code }
  name { Money::Currency.new('EUR').name }
end