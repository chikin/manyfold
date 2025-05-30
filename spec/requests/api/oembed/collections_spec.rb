# spec/requests/blogs_spec.rb
require "swagger_helper"

describe "Collections", :multiuser do # rubocop:disable RSpec/EmptyExampleGroup
  before { create(:admin) }

  path "/collections/{id}.oembed" do
    get "oEmbed response for Collections" do
      tags "Collections"
      produces "application/json+oembed"
      parameter name: :id, in: :path, type: :string
      parameter name: :maxwidth, in: :query, type: :integer, required: false
      parameter name: :maxheight, in: :query, type: :integer, required: false

      response "200", "Success" do
        schema oneOf:
          [
            {"$ref" => "#/components/schemas/oembed_rich"},
            {"$ref" => "#/components/schemas/oembed_photo"},
            {"$ref" => "#/components/schemas/oembed_video"},
            {"$ref" => "#/components/schemas/oembed_link"}
          ],
          discriminator: {
            propertyName: :type,
            mapping: {
              rich: "#/components/schemas/oembed_rich",
              photo: "#/components/schemas/oembed_photo",
              video: "#/components/schemas/oembed_video",
              link: "#/components/schemas/oembed_link"
            }
          }

        let(:id) { create(:collection, :public).to_param }
        run_test!
      end

      response "404", "Not Found or Unauthorized" do
        let(:id) { create(:collection).to_param }
        run_test!
      end
    end
  end
end
