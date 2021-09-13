module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :test_field_on_users, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
