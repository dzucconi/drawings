require_relative 'boot'

require "rails"

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module Drawings
  class Application < Rails::Application
    config.load_defaults 5.1

    config.generators.system_tests = nil

    config.generators do |g|
      g.test_framework false
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.channel assets: false
    end

    config.action_view.field_error_proc = proc { |tag|
      "<span class='Error'>#{tag}</span>".html_safe
    }
  end
end
