# frozen_string_literal: true

require "spec_helper"
describe Decidim::Blog::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:organization) { create :organization }
  let(:user) { create :user, organization: organization }
  let(:initiative) { create :initiative, author: user, organization: organization }
  let(:context) do
    {
      current_component: blog_component,
      current_user: user
    }
  end
  let(:blog_component) { create :post_component, participatory_space: initiative, organization: organization }
  let(:permission_action) { Decidim::PermissionAction.new(**action) }

  context "when scope is public" do
    let(:action) do
      { scope: :public, action: :foo, subject: :blogpost }
    end

    it { is_expected.to be true }
  end

  context "when scope is admin" do
    let(:action) do
      { scope: :admin, action: :foo, subject: :blogpost }
    end

    it { is_expected.to be true }
  end

  context "when scope is a random one" do
    let(:action) do
      { scope: :foo, action: :foo, subject: :blogpost }
    end

    it_behaves_like "permission is not set"
  end

  context "when subject is a random one" do
    let(:action) do
      { scope: :admin, action: :foo, subject: :foo }
    end

    it_behaves_like "permission is not set"
  end

  context "when action is from front office" do
    let(:action) do
      { scope: :public, action: :create, subject: :blogpost }
    end

    context "and user is the author of the initiative" do
      it { is_expected.to be true }
    end

    context "and user is not the author of the initiative" do
      let(:user2) { create :user, organization: organization }

      before do
        initiative.update!(author: user2)
      end

      it { is_expected.to be false }
    end
  end
end
