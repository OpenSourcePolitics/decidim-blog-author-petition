# frozen_string_literal: true

require "spec_helper"

module Decidim::Blogs
  describe PostPresenter, type: :helper do
    let(:post) { create :post, component: blog_component }
    let(:user) { create :user, :admin, organization: organization }

    let(:organization) { create(:organization) }
    let(:initiative) { create :initiative, organization: organization }
    let(:blog_component) { create(:post_component, participatory_space: initiative) }

    let(:presented_post) { described_class.new(post) }

    describe "#body" do
      let(:body1) do
        Decidim::ContentProcessor.parse_with_processor(:hashtag, "Description #description", current_organization: organization).rewrite
      end
      let(:body2) do
        Decidim::ContentProcessor.parse_with_processor(:hashtag, "Description in Spanish #description", current_organization: organization).rewrite
      end
      let(:post) do
        create(
          :post,
          component: blog_component,
          body: {
            en: body1,
            machine_translations: {
              es: body2
            }
          }
        )
      end

      it "parses hashtags in machine translations" do
        expect(post.body["en"]).to match(/gid:/)
        expect(post.body["machine_translations"]["es"]).to match(/gid:/)

        presented_body = presented_post.body(all_locales: true)
        expect(presented_body["en"]).to eq("Description #description")
        expect(presented_body["machine_translations"]["es"]).to eq("Description in Spanish #description")
      end

      context "when sanitizes any HTML input" do
        let(:body1) { %(<a target="alert(1)" href="javascript:alert(document.location)">XSS via target in a tag</a>) }

        it "removes the html input" do
          presented_body = presented_post.body(all_locales: true, strip_tags: true)
          expect(presented_body["en"]).to eq("XSS via target in a tag")
        end
      end
    end
  end
end
