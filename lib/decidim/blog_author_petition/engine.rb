# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module BlogAuthorPetition
    # This is the engine that runs on the public interface of blog_author_petition.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::BlogAuthorPetition

      routes do
        # Add engine routes here
        # resources :blog_author_petition
        # root to: "blog_author_petition#index"
      end

      initializer "BlogAuthorPetition.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
