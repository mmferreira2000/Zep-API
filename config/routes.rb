# frozen_string_literal:true

Rails.application.routes.draw do
  post 'create' => 'songs#create'
  get 'songs' => 'songs#index'
end
