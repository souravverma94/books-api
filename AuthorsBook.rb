require 'Sequel'

class AuthorsBook < Sequel::Model
  Sequel::Model.plugin :json_serializer
  many_to_one :author
  many_to_one :book
end