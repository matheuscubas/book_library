# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Books', type: :request do
  describe 'Books' do
    path '/api/books' do
      get 'Successfully return a list of books' do
        tags 'Books'
        description 'Endpoint used by the team to retrieve books'
        produces 'application/json'
        parameter name: :title, in: :query, type: :string, required: false
        parameter name: :author, in: :query, type: :string, required: false
        parameter name: :genre, in: :query, type: :string, required: false

        response(200, 'Return a list of books') do
          before do
            create_list(:book, 5)
          end

          run_test! do |request|
            body = JSON.parse(request.body, symbolize_names: true)
            expect(response).to have_http_status(200)
            expect(body.keys).to eq([:books])
            expect(body[:books].size).to eq(5)
          end

          context 'Return no errors without parameters' do
            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(200)
              expect(body.keys).to eq([:books])
              expect(body[:books].size).to eq(5)
            end
          end

          context 'Return just the books that has the same genre' do
            before do
              create(:book, genre: 'Impossible to exist')
            end

            let(:my_book) { Book.last }
            let(:genre) { 'Impossible to exist' }

            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(200)
              expect(body.keys).to eq([:books])
              expect(Book.count).not_to eq(1)
              expect(body[:books].first[:id]).to eq(my_book.id)
            end
          end

          context 'Return just the books that has the same author' do
            before do
              create(:book, author: 'Impossible to exist')
            end

            let(:my_book) { Book.last }
            let(:author) { 'Impossible to exist' }

            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(200)
              expect(body.keys).to eq([:books])
              expect(Book.count).not_to eq(1)
              expect(body[:books].first[:id]).to eq(my_book.id)
            end
          end

          context 'Return just the books that has the same title' do
            before do
              create(:book, title: 'Impossible to exist')
            end

            let(:my_book) { Book.last }
            let(:title) { 'Impossible to exist' }

            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(200)
              expect(body.keys).to eq([:books])
              expect(Book.count).not_to eq(1)
              expect(body[:books].first[:id]).to eq(my_book.id)
            end
          end

          context 'Return an empty array when no book match the criteria' do
            let(:title) { 'Impossible to exist' }

            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(200)
              expect(body.keys).to eq([:books])
              expect(Book.count).not_to eq(1)
              expect(body[:books]).to be_empty
            end
          end
        end
      end
    end
  end
end
