class Manifest
  include Elasticsearch::Persistence::Model

  attribute :manifest_id, String
  attribute :label,       String
  attribute :description, String
  attribute :raw_license,     String
  attribute :license,     String
   attribute :raw_license2, String
  attribute :raw_license3, String
  attribute :nav_date,     Date
  attribute :last_indexed_date, Date
  attribute :metadata, String
  attribute :domain, String
  attribute :thumbnail, String

  # The ActiveRecord pattern for the ElasticSearch Persistence gem doesn't automatically manage indexes


end
