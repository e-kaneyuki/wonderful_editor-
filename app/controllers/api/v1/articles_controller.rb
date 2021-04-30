module Api::V1
  class ArticlesController < BaseApiController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!, only: [:create, :update, :destroy]

    def index
      @articles = Article.order("updated_at")
      render json: @articles, each_serializer: ArticlePreviewSerializer
      # binding.pry
      # 記事全てを表示する
      # ActiveRecordを使ってインスタンス変数を設定
      # selectメソッドで”title”を指定.orderで昇順設定(〇〇 DESC)で降順に設定できる
      # 記事の例を作らないとhashが空だった
      # ActiveRecordでUserモデル、Articleモデル共に作成した
      # Usersテーブルに対し、articleテーブルの関係はBelongs_toなので、
      # まずはUserテーブルの入力から進めなければならなかった(user_idが必要になるとか)。
      # bindisng.pry
      # # ArtilePreviewsSerializer の表示方法はserializerを採用
      # renderって何？とりあえず今回は出力のパターンという理解で進める
      # 例えば＠articles(インスタンス変数)はjson形式で出力,
      # またArticlePreviewSerializerの内容は
      # each_serializer(serializerで出力したいデータが複数の場合はeach_serializer)で出力

      # 記事が新しい順に並び替えないといけない
    end

    # 4/26 showのif-elsif-else分を弄った
    def show
      if @articles.draft? && @articles.user.id != current_user.id
        flash[:alert] = "権限がありません"
        redirect_to root_path
      elsif @articles.published? || user_signed_in? && @articles.draft?
        @articles = Article.find(params[:id])
        render json: @articles, each_serializer: ArticleSerializer
      else
        flash[:alert] = "非公開です ログインしてください"
        redirect_to root_path
      end
    end

    def create
      @article = current_user.articles.create!(article_params)
      render json: @article, each_serializer: ArticleSerializer
    end

    def update
      @article = Article.find(params[:id])
      @article.update!(article_params)

      render json: @article, each_serializer: ArticleSerializer
    end

    def destroy
      @article = Article.find(params[:id])
      @article.delete
    end

    def toggle_status
      @salon.toggle_status!
      redirect_to dashboard_path, notice: "ステータスを変更しました"
    end

    private

      def article_params
        params.require(:article).permit(:title, :body)
      end
  end
end
