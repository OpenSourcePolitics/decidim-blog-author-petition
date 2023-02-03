# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/blog_author_petition/version"

Gem::Specification.new do |s|
  s.version = Decidim::BlogAuthorPetition.version
  s.authors = ["Elie Gaboriau"]
  s.email = ["elie@opensourcepolitics.eu"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-blog_author_petition"
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-blog_author_petition"
  s.summary = "A decidim blog_author_petition module"
  s.description = "It enables the author of a petition to manage its actualities."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::BlogAuthorPetition.decidim_compatibility_version
  s.metadata["rubygems_mfa_required"] = "true"
end
