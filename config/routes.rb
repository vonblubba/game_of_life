# frozen_string_literal: true

Rails.application.routes.draw do
  resources :generation, only: [:show] do
    collection do
      get :upload
      post :perform_upload
    end
  end

  root to: 'generation#upload'
end
