# frozen_string_literal: true

require "spec_helper"

describe "Author manages blog posts", type: :system do
  include_context "with a component"

  let(:manifest_name) { "blogs" }
  let(:participatory_space) { create :initiative, organization: organization, author: user }
  let!(:post1) { create :post, author: user, component: component, title: { en: "Post title 1" } }
  let!(:post2) { create :post, component: component, title: { en: "Post title 2" } }

  context "when user is the author of the initiative" do
    before do
      login_as(user, scope: :user)
      visit_component
    end

    it "enables to create" do
      expect(page).to have_content("New post")

      click_link("New post")

      fill_in(:post_title, with: "title")
      fill_in(:post_body, with: "body")

      click_button("Create")

      expect(page).to have_content("successfully")
      expect(Decidim::Blogs::Post.last.author).to eq(user)
    end

    context "when user is the author of the post" do
      before do
        login_as(user, scope: :user)
        visit_component
        click_link(post1.title["en"])
      end

      it "enables to update" do
        expect(page).to have_content("Edit post")

        click_link("Edit post")

        fill_in(:post_title, with: "title2")
        fill_in(:post_body, with: "body")

        click_button("Update")

        expect(page).to have_content("successfully")
        expect(post1.reload.title).to eq({ "en" => "title2" })
        expect(post1.reload.author).to eq(user)
      end

      it "enables to destroy" do
        expect(page).to have_content("Delete post")

        click_link("Delete post")

        expect(page).to have_content("successfully")
        expect(Decidim::Blogs::Post.count).to eq(1)
      end
    end

    context "when user is not the author of the post" do
      before do
        login_as(user, scope: :user)
        visit_component
        click_link(post2.title["en"])
      end

      it "doesn't enable to update" do
        expect(page).not_to have_content("Edit post")
      end

      it "doesn't enable to destroy" do
        expect(page).not_to have_content("Delete post")
      end
    end
  end

  context "when user is not the author of the initiative" do
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
