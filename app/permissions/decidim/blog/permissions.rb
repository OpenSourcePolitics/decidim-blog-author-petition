# frozen_string_literal: true

module Decidim
  module Blog
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless permission_action.subject == :blogpost

        if permission_action.action.in?([:update, :create, :destroy])
          toggle_allow(can_manage_post)
          return permission_action
        end

        if permission_action.scope == :public
          allow!
          return permission_action
        end

        return permission_action if permission_action.scope != :admin

        allow!
        permission_action
      end

      def post
        @post ||= context.fetch(:blogpost, nil)
      end

      def current_component
        @current_component ||= context.fetch(:current_component, nil)
      end

      def can_manage_post
        current_component&.participatory_space.is_a?(Decidim::Initiative) && user == current_component&.participatory_space&.author
      end
    end
  end
end
