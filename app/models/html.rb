# frozen_string_literal: true

require 'rouge/plugins/redcarpet'

class Html < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
