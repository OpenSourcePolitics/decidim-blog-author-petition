# frozen_string_literal: true

module Decidim
  module Blogs
    # Custom helpers used in posts views
    module PostsSelectHelper
      include Decidim::ApplicationHelper
      include SanitizeHelper

      def fo_post_author_select_field(form, name, _options = {})
        select_options = [
          [current_user.name, current_user.id]
        ]
        current_user_groups = Decidim::UserGroups::ManageableUserGroups.for(current_user).verified

        select_options += current_user_groups.map { |g| [g.name, g.id] } if current_organization.user_groups_enabled? && current_user_groups.any?
        select_options << [form.object.author.name, form.object.author.id] unless form.object.author.is_a?(Organization) || select_options.pluck(1).include?(form.object.author.id)

        form.select(name, select_options)
      end
    end
  end
end
