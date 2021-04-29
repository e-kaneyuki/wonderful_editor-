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
FactoryBot.define do
  factory :article do
    sequence(:title) {|n| "#{n}_#{Faker::Lorem.word}" }
    sequence(:body) {|n| "#{n}_#{Faker::Lorem.sentence}" }
    sequence(:updated_at) {|n| "#{n}_#{Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :long)}" }
    user
  end
end
