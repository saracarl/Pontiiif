class Manifest
  include Elasticsearch::Persistence::Model

  attribute :manifest_id, String
  attribute :label,       String
  attribute :description, String
  attribute :license,     String
  attribute :navDate,     Date
end
