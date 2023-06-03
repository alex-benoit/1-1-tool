# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#settings'

  resources :supervisions, only: %i[new create show]

  devise_for :users
end
