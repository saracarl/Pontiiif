class Collection
  include Elasticsearch::Persistence::Model

  attribute :collection_id, String
  attribute :index_started, DateTime
  attribute :index_finished, DateTime
  

  mapping do
    indexes :collection_id, :index => :uax_url_email
  end

  def self.find_by_at_id(at_id)
    definition = Elasticsearch::DSL::Search.search do 
      query do 
        term collection_id: at_id
      end
    end
    Collection.search(definition.to_hash).first
  end

end
