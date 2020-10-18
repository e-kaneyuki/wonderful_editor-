class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  belongs_to :user, serializer: Api::V1::UserSerializer
end
