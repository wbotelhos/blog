# frozen_string_literal: true

module Helper
  module_function

  def true?(value)
    [true, 'true', 1, '1', 'on'].include?(value)
  end
end
