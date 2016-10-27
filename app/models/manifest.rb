class Manifest
  include Elasticsearch::Persistence::Model

  attribute :manifest_id, String
  attribute :label,       String
  attribute :description, String
  attribute :raw_license,     String
  attribute :license,     String
  #attribute :license, String, mapping: { index: { analysis: { analyzer: "url_analyzer" } } }
 # attribute :raw_license2, String, mapping: { index: 'not_analyzed'}
   attribute :raw_license2, String
  attribute :raw_license3, String
  attribute :navDate,     Date
  attribute :lastIndexedDate, Date
  attribute :metadata, String
  attribute :domain, String

  mapping do
  # 	indexes :manifest_id,	:index => :uax_url_email
  #  	indexes :domain,    	:index => :uax_url_email
  #  	indexes	:license,		:index => :uax_url_email
  #indexes :license, analyzer: "url_analyzer"
  #  	#indexes :raw_license,	:index => :uax_url_email
  #  	#indexes :raw_license2,	:index => :not_analyzed
  #  	indexes :raw_license3,	:index => :not_analyzed
  end



end
