module JsonLd
  class CreatorListSerializer < ApplicationSerializer
    def serialize
      {
        "@context": context,
        "@id": Rails.application.routes.url_helpers.creators_path,
        "@type": "hydra:Collection",
        totalItems: @object.total_count,
        member: @object.map { |creator|
          {
            "@id": Rails.application.routes.url_helpers.creator_path(creator),
            name: creator.name
          }
        },
        view: {
          "@id": Rails.application.routes.url_helpers.creators_path(page: @object.current_page),
          "@type": "hydra:PartialCollectionView",
          first: Rails.application.routes.url_helpers.creators_path(page: 1),
          previous: (Rails.application.routes.url_helpers.creators_path(page: @object.prev_page) if @object.prev_page),
          next: (Rails.application.routes.url_helpers.creators_path(page: @object.next_page) if @object.next_page),
          last: Rails.application.routes.url_helpers.creators_path(page: @object.total_pages)
        }.compact
      }
    end
  end
end
