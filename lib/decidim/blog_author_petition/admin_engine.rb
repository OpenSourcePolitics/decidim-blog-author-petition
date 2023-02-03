# frozen_string_literal: true

module Decidim
  module BlogAuthorPetition
    # This is the engine that runs on the public interface of `BlogAuthorPetition`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::BlogAuthorPetition::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :blog_author_petition do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "blog_author_petition#index"
      end

      def load_seed
        nil
      end
    end
  end
end
