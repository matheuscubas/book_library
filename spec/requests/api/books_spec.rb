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
        consumes 'application/json'
        parameter name: :book, in: :body, schema: { '$ref' => '#/components/schemas/book' }

        response(200, 'Successfully create a book') do
          let(:book) { attributes_for(:book) }

          run_test! do |request|
            body = JSON.parse(request.body, symbolize_names: true)
            expect(response).to have_http_status(200)
            expect(body.keys).to eq([:book])
            expect(Book.count).to eq(1)
            expect(Book.last.title).to eq(book[:title])
          end
        end

        response(422, 'Return error with invalid parameters') do
          let(:book) { attributes_for(:book, title: '') }

          run_test! do |request|
            body = JSON.parse(request.body, symbolize_names: true)
            expect(response).to have_http_status(422)
            expect(body.keys).to eq([:error])
            expect(body[:error]).to eq({ title: ["can't be blank", 'is too short (minimum is 2 characters)'] })
          end

          context 'With invalid author' do
            let(:book) { attributes_for(:book, author: '') }

            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(422)
              expect(body.keys).to eq([:error])
              expect(body[:error]).to eq({ author: ["can't be blank", 'is too short (minimum is 2 characters)'] })
            end
          end

          context 'With invalid genre' do
            let(:book) { attributes_for(:book, genre: '') }

            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(422)
              expect(body.keys).to eq([:error])
              expect(body[:error]).to eq({ genre: ["can't be blank", 'is too short (minimum is 2 characters)'] })
            end
          end

          context 'With invalid publication_year' do
            let(:book) { attributes_for(:book, publication_year: Date.today.year + 1) }
            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(422)
              expect(body.keys).to eq([:error])
              expect(body[:error]).to eq({ publication_year: ['must be less than or equal to 2023'] })
            end
          end

          context 'Without publication_year' do
            let(:book) { attributes_for(:book, publication_year: '') }
            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(422)
              expect(body.keys).to eq([:error])
              expect(body[:error]).to eq({ publication_year: ["can't be blank"] })
            end
          end

          context 'With an already existing book' do
            let(:book) { attributes_for(:book) }

            before do
              Book.create(book)
            end

            run_test! do |request|
              body = JSON.parse(request.body, symbolize_names: true)
              expect(response).to have_http_status(422)
              expect(body.keys).to eq([:error])
              expect(body[:error]).to eq({ uniqueness: ["#{book[:title]} already been recomended before."] })
            end
          end
        end
      end
    end
  end
end
