# frozen_string_literal: true

Rails.application.routes.draw do
  get 'projects/index'
  get 'projects/show'
  get 'projects/new'
  get 'projects/edit'
  devise_for :users

  resources :projects do
    resources :tasks, only: [:index]
    collection do
      patch :sort
    end
  end
  resources :tasks do
    member do
      patch :toggle_done
    end
  end
  resources :tags

  root 'tasks#index'
end
