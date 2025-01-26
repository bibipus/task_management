# frozen_string_literal: true

Rails.application.routes.draw do
  get 'projects/index'
  get 'projects/show'
  get 'projects/new'
  get 'projects/edit'
  devise_for :users

  resources :projects
  resources :tasks
  resources :tags

  root 'tasks#index'
end
