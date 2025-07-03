module Api
  module V1
    module Projects
      class ProjectIndexSerializer < ActiveModel::Serializer
        attributes :id, :title, :summary, :status, :tech_stack, :urls

        def summary
          object.description.truncate(50)
        end

        def tech_stack
          object.technology_stack
        end

        def urls
          {
            repo: object.repository_url,
            live: object.live_url
          }
        end
      end
    end
  end
end
