module Types
  class UserType < Types::BaseObject
    key fields: 'id'
    extend_type

    field :id, ID, null: false, external: true
    field :articles, Types::ArticleType.connection_type, null: true

    def articles
      [RecordLoader.for(Article, column: :user_id).load(object[:id])]
    end
  end
end
