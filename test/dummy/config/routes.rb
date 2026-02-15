# frozen_string_literal: true

Rails.application.routes.draw do
  if defined?(Lookbook)
    mount Lookbook::Engine, at: "/lookbook"
  end
end
