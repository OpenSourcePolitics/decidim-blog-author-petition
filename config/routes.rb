# frozen_string_literal: true

Decidim::Blogs::Engine.routes.draw do
  resources :posts, except: [:index, :show]
end
