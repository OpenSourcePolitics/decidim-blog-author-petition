# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :blog_author_petition_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :blog_author_petition).i18n_name }
    manifest_name :blog_author_petition
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
