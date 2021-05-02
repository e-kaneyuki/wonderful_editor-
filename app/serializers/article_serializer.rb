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
class ArticleSerializer < ActiveModel::Serializer
  # articleのindex以外のAPI処理をいれる場所 ※serializerは簡便にJson形式で表示する為のディレクトリということは覚えておく
  attributes :id, :title, :updated_at, :body
  belongs_to :user, serializer: UserSerializer
  # has_many :comments, :article_likes
end
