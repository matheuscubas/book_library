# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Books', type: :request do
  describe 'Books' do
    path '/api/books' do
      get 'Successfully return a list of books' do
        tags 'Books'
        description 'Endpoint used by the team to retrieve books'
        produces 'application/json'

        before do
          create_list(:book, 5)
        end

        response(200, 'Return a list of 5 books') do
          run_test! do |request|
            body = JSON.parse(request.body, symbolize_names: true)
            expect(response).to have_http_status(200)
            expect(body.keys).to eq(%i[data meta])
            expect(body.data.size).to eq(5)
          end
        end
      end
    end
  end
end
