# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_visitantes-backend_session'

# Sigre::Application.config.session_store :cookie_store, key: '_sigre_session'

ApplicationController.config.session_store :cookie_store, key: '_sigre_session'