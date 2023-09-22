# frozen_string_literal: true

module Api
  class BooksController < ::ApplicationController
    def index
      result = ::BooksIndexQuery.call(query: query_params)
      render result
    end

    def create; end

    private

    def query_params
      params.permit(:title, :genre, :author)
    end
  end
end
