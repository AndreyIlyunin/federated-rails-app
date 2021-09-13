module Types
  class ArticleType < Types::BaseObject
    key fields: ['id', 'user_id']

    field :id, ID, null: false
    field :user_id, Integer, null: true
    field :user, Types::UserType, null: true
    field :content, String, null: true

    def self.resolve_reference(object, _context)
      binding.pry
      # RecordLoader.for(Article).load(object[:id])
      Article.where(user_id: object[:id])
    end

    def user
      { __typename: 'User', id: object[:user_id] }
    end
  end
end
