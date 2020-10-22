require 'Sequel'

class Author < Sequel::Model
  Sequel::Model.plugin :json_serializer
  set_primary_key :author_id
  one_to_many :authors_books
  many_to_many :books, join_table: :authors_books, left_key: :author_id, right_key: :book_id
end