# frozen_string_literal: true

require "rails"
require "active_support/all"
require "decidim/core"

module Decidim
  module BlogAuthorPetition
    # This is the engine that runs on the public interface of blog_author_petition.
    class Engine < ::Rails::Engine
      initializer "decidim_blog_author_petition.overrides" do
        config.to_prepare do
          Decidim::Blogs::Admin::CreatePost.class_eval do
            prepend(::CreatePostExtends)
          end

          Decidim::Blogs::PostsController.class_eval do
            include(::PostsControllerExtends)
          end
        end
      end

      initializer "BlogAuthorPetition.mount_routes" do
        Decidim::Blogs::Engine.routes.prepend do
          resources :posts, except: [:index, :show]
        end
      end

      initializer "BlogAuthorPetition.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "BlogAuthorPetition.disable_endorsements" do
        Decidim.find_component_manifest(:blogs).settings(:step).attributes[:endorsements_enabled].default = false
      end
    end
  end
end
