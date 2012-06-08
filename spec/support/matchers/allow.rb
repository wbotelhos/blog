RSpec::Matchers.define :allow do |*values|
  failed = []
  attribute = nil

  match do |record|
    values.each do |value|
      record.public_send("#{attribute}=", value)
      failed << value unless record.valid? || record.errors[attribute].empty?
    end

    failed.empty?
  end

  chain :for do |name|
    attribute = name
  end

  failure_message_for_should do |record|
    "expected #{failed.inspect} to be allowed"
  end

  failure_message_for_should_not do |record|
    "expected #{(values - failed).inspect} to be rejected"
  end

  description do
    "allow #{values.inspect} for #{attribute.inspect} attribute"
  end
end
