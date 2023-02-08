# frozen_string_literal: true

module CreatePostExtends
  def call
    return broadcast(:invalid) if @form.invalid?

    transaction do
      post = create_post!
      create_comment_permission_for(post) if create_comment_permission?
      send_notification
    end

    broadcast(:ok, @post)
  end

  def create_comment_permission?
    comments_authorization_handler
  end

  def create_comment_permission_for(post)
    form = Decidim::Admin::PermissionsForm.from_params(ah_comment_hash)
                                          .with_context(current_organization: post.organization)

    Decidim::Admin::UpdateResourcePermissions.call(form, post)
  end

  def ah_comment_hash
    { "component_permissions" => { "permissions" => { "comment" => { "authorization_handlers" => [comments_authorization_handler] } } } }
  end

  private

  def comments_authorization_handler
    @comments_authorization_handler ||= Rails.application.secrets.dig(:decidim, :initiatives, :permissions, :comments, :authorization_handler)
  end
end
