# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Books', type: :request do
  describe 'Books' do
    path '/api/books' do
      get 'Return a list of books' do
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

      post 'Create a new book' do
        tags 'Books'
        description 'Endpoint used by the team to create a new book'
        produces 'application/json'
        parameter name: :title, in: :body, type: :string, required: true
        parameter name: :author, in: :body, type: :string, required: true
        parameter name: :genre, in: :body, type: :string, required: true
        parameter name: :publication_year, in: :body, type: :string, required: true

        response(200, 'Successfully create a book') do
          let(:book_params) { attributes_for(:book) }

          run_test! do |request|
            body = JSON.parse(request.body, symbolize_names: true)
            expect(response).to have_http_status(200)
            expect(body.keys).to eq([:book])
            expect(Book.count).to eq(1)
            expect(Book.last.title).to eq(book_params[:title])
          end
        end
      end
    end
  end
end
