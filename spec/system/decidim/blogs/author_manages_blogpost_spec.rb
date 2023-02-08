# frozen_string_literal: true

require "spec_helper"

describe "Author manages blog posts", type: :system do
  include_context "with a component"

  let(:manifest_name) { "blogs" }
  let(:participatory_space) { create :initiative, organization: organization, author: user }
  let!(:post1) { create :post, component: component, title: { en: "Post title 1" } }
  let!(:post2) { create :post, component: component, title: { en: "Post title 2" } }

  context "when user is the author" do
    before do
      login_as(user, scope: :user)
      visit_component
    end

    it "enables to create" do
      expect(page).to have_content("New post")

      click_link("New post")

      expect(page).to have_select("post_decidim_author_id")

      fill_in(:post_title, with: "title")
      fill_in(:post_body, with: "body")

      click_button("Create")

      expect(page).to have_content("successfully")
    end

    it "enables to update" do
      click_link(post1.title["en"])

      expect(page).to have_content("Edit post")

      click_link("Edit post")

      expect(page).to have_select("post_decidim_author_id")

      fill_in(:post_title, with: "title2")
      fill_in(:post_body, with: "body")

      click_button("Update")

      expect(page).to have_content("successfully")
      expect(post1.reload.title).to eq({ "en" => "title2" })
    end

    it "enables to destroy" do
      click_link(post1.title["en"])

      expect(page).to have_content("Delete post")

      click_link("Delete post")

      expect(page).to have_content("successfully")
      expect(Decidim::Blogs::Post.count).to eq(1)
    end
  end

  context "when user is not the author" do
    let!(:author2) { create :user, organization: organization }

    before do
      participatory_space.update!(author: author2)
      visit_component
    end

    it "doesn't enable to create" do
      expect(page).not_to have_content("New post")
    end

    it "doesn't enable to update nor destroy" do
      click_link(post1.title["en"])

      expect(page).not_to have_content("Edit post")
      expect(page).not_to have_content("Destroy post")
    end
  end
end
