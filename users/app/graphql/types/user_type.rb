module Types
  class UserType < Types::BaseObject
    key fields: 'id'

    field :id, ID, null: false
    field :login, String, null: true

    def self.resolve_reference(object, _context)
      RecordLoader.for(User).load(object[:id])
    end
  end
end
