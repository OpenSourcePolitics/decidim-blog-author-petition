# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  decidim_blog_author_petition: "#{base_path}/app/packs/entrypoints/decidim_blog_author_petition.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/blog_author_petition/blog_author_petition")
