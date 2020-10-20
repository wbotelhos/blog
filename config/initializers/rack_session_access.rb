# frozen_string_literal: true

Rails.application.config.middleware.use(RackSessionAccess::Middleware) if Rails.env.test?
