# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

base_path = "../" if File.basename(__dir__) == "development_app"
require_relative "#{base_path}lib/decidim/blog_author_petition/version"

DECIDIM_VERSION = Decidim::BlogAuthorPetition.decidim_compatibility_version

gem "decidim", DECIDIM_VERSION
gem "decidim-blog_author_petition", path: "."

gem "bootsnap", "~> 1.4"
gem "puma", ">= 4.3"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.0"
end
