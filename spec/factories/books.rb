# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'MyString' }
    author { 'MyString' }
    genre { 'MyString' }
    publication_year { 'MyString' }
  end
end
