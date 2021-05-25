require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  ########################## index  start ##############################
  describe "GET /index" do
    # binding.pry
    subject { get(api_v1_articles_path) }

    before { FactoryBot.build_list(:article, 5) }

    it "Articleモデルのindexメソッドに接続できる" do
      subject

      expect(response).to have_http_status(:success)
    end

    context "記事が存在する" do
      it "記事の一覧が表示できる" do
        article = FactoryBot.build(:article)

        expect(article).to be_valid
      end
    end

    context "記事が存在しない" do
      it "記事の一覧が表示できない" do
        article = FactoryBot.build(:article, title: nil)
        expect(article).to be_invalid
      end
    end
  end

  describe "GET /show" do
    subject { get(api_v1_article_path(article_id)) }

    # context "選択されたレコードに記事が存在する場合" do
    #   let(:article) { create(:article) }
    #   let(:article_id) { article.id }

    #   it "指定された記事が表示される" do
    #     subject
    #     res = JSON.parse(response.body)
    #     expect(response).to have_http_status(:ok)

    #     expect(res["title"]).to eq article.title
    #     expect(res["body"]).to eq article.body
    #     expect(res["user"]["id"]).to eq article.user.id
    #   end
    # end

    context "選択されたレコードに記事が存在しない場合" do
      let(:article) { create(:article) }
      let(:article_id) { 10000 }
      it "指定された記事が表示されない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  ########################## create  start ##################################
  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    let(:my_instance) { instance_double(Api::V1::BaseApiController) }

    let(:headers) { current_user.create_new_auth_token }

    it "記事のレコードが作成できる" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
      res = JSON.parse(response.body)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end
end
