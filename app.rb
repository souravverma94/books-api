require 'sinatra'
require 'sinatra/reloader'
require 'pry'

class MyApp < Sinatra::Base
    configure do
        register Sinatra::Reloader
    end

    get '/test' do
        @books = Author.eager_graph(books: :authors_books)
        @books.to_json
    end
    get '/books' do
        @books = Book.all
        res =[]
        @books.each{ |book|
            res.push({book: book, authors: book.authors})
        }
        res.to_json
    end

    get '/books/:book_id' do
        @book = Book.find(book_id: params['book_id'])
        @book.to_json
    end

    get '/authors' do
        @authors = Author.all
        res =[]
        @authors.each{ |author|
            res.push({author: author, books: author.books})
        }
        res.to_json
    end

    get '/authors/:author_id' do
        @author = Author.find(author_id: params['author_id'])
        total = @author.books.size
        {author: @author, total_books: total}.to_json
    end

    get '/authors/:author_id/books' do
        @auth = Author.find(author_id: params['author_id'])
        @auth.books.to_json
    end

    post '/authors/:author_id/books' do
        @book = JSON.parse request.body.read
        @auth = Author.find(author_id: params['author_id'])
        if @auth
            @auth.add_book(@book)
        else
            return 'Author Not Found'
        end
        @book.to_json
    end

    get '/authors/:author_id/books/:book_id' do
        @auth_book = AuthorsBook.find({author_id: params['author_id'], book_id: params['book_id']})
        if @auth_book
            @auth_book.book.to_json
        else
            'Book Not Found'
        end
    end

    delete '/authors/:author_id/books/:book_id' do
        @auth_book = AuthorsBook.find({author_id: params['author_id'], book_id: params['book_id']})
        if @auth_book
            book = @auth_book.book
            @auth_book.destroy
            book.destroy
            status '202'
        else
            'Book Not Found'
        end
    end
end 