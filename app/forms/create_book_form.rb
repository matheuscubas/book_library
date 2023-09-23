# frozen_string_literal: true

class CreateBookForm
  include ActiveModel::Model

  attr_accessor :title, :genre, :author, :publication_year

  validates :title, :genre, :author, presence: true
  validates :title, :genre, :author, length: { minimum: 2 }
  validates :publication_year, comparison: { less_than_or_equal_to: Date.today.year }
  validate  :uniqueness

  def persist
    return false unless valid?

    Book.create(title:, genre:, author:, publication_year:)
  end

  private

  def uniqueness
    return true unless Book.where(title:, publication_year:, author:).any?

    errors.add(:uniqueness, message: "#{title} already been recomended before.")
    false
  end
end
