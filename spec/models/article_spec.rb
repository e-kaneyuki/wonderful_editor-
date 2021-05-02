# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer          default("draft"), not null
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

# RSpec.describe Article, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
RSpec.describe "Articles", type: :model do
  # before do
  #   @article = article
  # end

  describe "GET /articles" do
    # before do
    #   @article = article
    # end
    # binding.pry
    ######################## 正常系 ###################################
    context "タイトルが記載されている場合" do
      it "記事一覧に表示される" do
        article = Article.new(title: "foo", body: "foo")
        # article = Article.new
        expect(article).to be_valid
        # expect("GET/articles").to be_valid
        # binding.pry
      end
      # binding.pry
    end

    context "タイトルが記載されていない場合" do
      it "記事一覧に表示されない" do
        article = Article.new(body: "foo")
        expect(article).to be_invalid
        expect(article.errors.details[:title][0][:error]).to eq :blank
      end
    end

    # context "タイトルと記事が記載されていない" do
    #   it "記事一覧に表示される" do
    #     article = Article.new
    #     expect(article).to be_invalid
    #     expect(article.errors.details[:title][0][:error]).to eq :blank
    #     # binding.pry
    #   end
    # end
  end
end
