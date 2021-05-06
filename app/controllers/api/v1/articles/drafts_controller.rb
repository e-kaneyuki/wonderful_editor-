class Api::V1::Articles::DraftsController < ApplicationController
  # ApplicationController ⇨ BaseApiController
  # このControllerは下書きをindexで一覧表示できるか、showで詳細を選択的に表示するかを決めるものとして設定していく
  def index
    # binding.pry
    articles = Article.where(status: 0)
    render json: @articles, each_serializer: ArticlePreviewSerializer
  end

  def show
    # binding.pry
    article = Article.draft.find(params[:id])
    render json: article
  end
end
