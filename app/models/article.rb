# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer          default(NULL), not null
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
class Article < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
  enum status: { draft: false, published: true }

  validates :title, presence: true # 追加
  validates :status, inclusion: { in: Article.statuses.keys }

  def toggle_status!
    draft? ? published! : draft!
  end
end
