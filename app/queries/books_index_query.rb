# frozen_string_literal: true

class BooksIndexQuery < BaseQuery
  def initialize(query:)
    @query = query
  end

  def call(query: @query, collection: Book.all)
    return { json: { books: collection } } if query.empty?

    execute_query(query:, collection:)
  end

  private

  def execute_query(query:, collection:)
    collection = collection.where(title: query[:title]) if query[:title].present?
    collection = collection.where(author: query[:author]) if query[:author].present?
    collection = collection.where(genre: query[:genre]) if query[:genre].present?

    { json: { books: collection } }
  end
end
