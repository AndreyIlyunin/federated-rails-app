module Types
  class MutationType < Types::BaseObject
    field :test_field_on_articles, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
