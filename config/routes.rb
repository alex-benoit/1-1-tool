# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#settings'

  get 'error', to: 'pages#error'

  resources :supervisions, only: %i[new create show]

  resources :checkins, only: %i[new create]

  devise_for :users
end
