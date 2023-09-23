# frozen_string_literal: true

module Api
  class BooksController < ::ApplicationController
    def index
      result = ::BooksIndexQuery.call(query: query_params)
      render result
    end

    def create
      book = Book.new(create_params)

      if book.save
        render json: { book: }
      else
        render status: :unprocessable_entity, json: { error: book.errors.messages }
      end
    end

    private

    def query_params
      params.permit(:title, :genre, :author)
    end

    def create_params
      params.permit(:title, :genre, :author, :publication_year)
    end
  end
end
