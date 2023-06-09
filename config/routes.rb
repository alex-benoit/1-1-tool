# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#settings'

  get 'error', to: 'pages#error'

  post :feedback_chat, to: 'feedback_chats#chat'

  resources :relationships, only: %i[new create show] do
    resources :topics, only: %i[update destroy]
  end

  resources :checkins, only: %i[new create]

  devise_for :users
end
