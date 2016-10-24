class Collection
  include Elasticsearch::Persistence::Model

  attribute :collection_id, String
  attribute :lastIndexedDate, Date

  mapping do
    indexes :collection_id, :index => :uax_url_email
  end

end
