module Api
  module V1
    module Projects
      class ProjectSerializer < ActiveModel::Serializer
        attributes :id,
                   :title,
                   :description,
                   :status,
                   :technology_stack,
                   :repository_url,
                   :live_url,
                   :notes,
                   :created_at,
                   :updated_at
      end
    end
  end
end
