require './app'
require 'sequel'
require 'yaml'

configure do
    env = "development"
    DB = Sequel.connect(YAML.load(File.open('./db.yml'))[env])

    DB.create_table? :books do
        primary_key(:book_id)
        String :book_title
        Integer :book_pages
        Float :book_price
    end

    DB.create_table? :authors do
        primary_key(:author_id)
        String :author_name
    end
    unless DB.table_exists?(:authors_books)
        DB.create_join_table(:author_id=>:authors, :book_id=>:books)
    end
    Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each do |model|
        require model
       end
end
run MyApp