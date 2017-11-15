# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 5.0 upgrade.
#
# Read the Guide for Upgrading Ruby on Rails for more info on each option.

# Make Ruby 2.4 preserve the timezone of the receiver when calling `to_time`.
# Previous versions had false.
ActiveSupport.to_time_preserves_timezone = true

# Require `belongs_to` associations by default. Previous versions had false.
Rails.application.config.active_record.belongs_to_required_by_default = true

# Do not halt callback chains when a callback returns false. Previous versions had true.
### ActiveSupport.halt_callback_chains_on_return_false = false
### DEPRECATION WARNING: ActiveSupport.halt_callback_chains_on_return_false= is deprecated and will be removed in Rails 5.2. (called from <top (required)> at /home/calderas/rails/visitantes-backend/config/initializers/new_framework_defaults.rb:15)

# Configure SSL options to enable HSTS with subdomains. Previous versions had false.
#Rails.application.config.ssl_options = { hsts: { subdomains: true } }
Rails.application.config.ssl_options = { hsts: false }
