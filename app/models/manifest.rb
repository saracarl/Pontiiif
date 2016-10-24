class Manifest
  include Elasticsearch::Persistence::Model

  attribute :manifest_id, String
  attribute :label,       String
  attribute :description, String
  attribute :license,     String
  attribute :license_raw, String
  attribute :navDate,     Date
  attribute :lastIndexedDate, Date
  attribute :metadata, String
  attribute :domain, String

  mapping do
  	indexes :manifest_id,	:index => :uax_url_email
   	indexes :domain,    	:index => :uax_url_email
   	indexes	:license,		:index => :uax_url_email
   	indexes :raw_license,	:index => :not_analyzed
  end

end
