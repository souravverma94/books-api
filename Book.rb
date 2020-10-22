require 'Sequel'

class Book < Sequel::Model
  Sequel::Model.plugin :json_serializer
  set_primary_key :book_id
  one_to_many :authors_books
  many_to_many :authors, left_key: :book_id, right_key: :author_id, join_table: :authors_books
end