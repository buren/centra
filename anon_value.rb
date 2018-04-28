# Consistently anonymize a value
class AnonValue
  def value_for(value)
    (@data ||= {}).fetch(value) { @data[value] = yield }
  end
end
