class ProjectSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :description,
             :status,
             :technology_stack,
             :repository_url,
             :live_url,
             :notes
end
