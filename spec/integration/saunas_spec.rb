require 'swagger_helper'

describe 'Sauna API' do
  path '/saunas' do
    post 'Создание сауны' do
      tags 'Saunas'
      consumes 'application/json'
      parameter name: :sauna, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          house: { type: :string },
          lat: { type: :number },
          lon: { type: :number },
          notes: { type: :string },
          street_uuid: { type: :uuid },
          logotype: {
            type: :object,
            properties: {
              value: { type: :string },
              filename: { type: :string },
              filetype: { type: :string }
            }
          }
        },
        required: %w[name house street_uuid]
      }

      response '200', 'Сауна успешно создана' do
        schema type: :object,
               properties: {
                 msg: { type: :integer }
               },
               required: %w[msg]
        let(:sauna) { { name: 'foo', house: '10', street_uuid: '9764a4dd-c5cf-4c1b-802d-6ecafa9d9fb7' } }
        run_test!
      end

      # response '422', 'invalid request' do
      #   let(:sauna) { { title: 'foo' } }
      #   run_test!
      # end
    end
  end

  put '/saunas/{id}' do
    get 'Обновление основной информации о сауне' do
      tags 'Saunas'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      parameter name: :sauna, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          house: { type: :string },
          lat: { type: :number },
          lon: { type: :number },
          notes: { type: :string },
          street_uuid: { type: :uuid },
          logotype: {
            type: :object,
            properties: {
              value: { type: :string },
              filename: { type: :string },
              filetype: { type: :string }
            }
          }
        }
      }

      # response '200', 'blog found' do
      #   schema type: :object,
      #          properties: {
      #            id: { type: :integer },
      #            title: { type: :string },
      #            content: { type: :string }
      #          },
      #          required: %w[id title content]

      #   let(:id) { Blog.create(title: 'foo', content: 'bar').id }
      #   run_test!
      # end

      # response '404', 'blog not found' do
      #   let(:id) { 'invalid' }
      #   run_test!
      # end

      # response '406', 'unsupported accept header' do
      #   let(:Accept) { 'application/foo' }
      #   run_test!
      # end
    end
  end
end
