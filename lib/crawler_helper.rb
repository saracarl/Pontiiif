require 'logger_helper'

module CrawlerHelper
  include LoggerHelper
  
  def self.ingest_manifest(manifest)
    unless manifest_already_exists(manifest)
      begin
    	 connection = open(manifest, :allow_redirections => :safe)
      rescue StandardError=>e
        LoggerHelper.log_error(e,manifest)
      else
        manifest_json = connection.read
        parse_manifest(manifest, manifest_json) 
      end
    else
      puts "manifest " + manifest + " has already been processed.  Not reprocessing."
    end
  end

  def self.manifest_already_exists(manifest)
    definition = Elasticsearch::DSL::Search.search do 
      query do 
        term manifest_id: manifest
      end
    end
    first_manifest = Manifest.search(definition.to_hash).first
    if first_manifest.nil? then
      false
    else
      first_manifest.manifest_id.eql? manifest
    end
  end

  def self.parse_manifest(manifest, manifest_json)
    begin
      service = IIIF::Service.parse(manifest_json)
    rescue StandardError=>e
      LoggerHelper.log_error(e,manifest)
    else
      new_manifest = Manifest.new
      new_manifest.manifest_id = service['@id']
      new_manifest.domain = URI.parse(manifest).host.downcase
      new_manifest.label = service.label
      new_manifest.thumbnail = service.thumbnail
      if service.description
        new_manifest.description = service.description
      end
      if service.license
        new_manifest.license = service.license
      end
      if service["nav_date"]  
        new_manifest.nav_date = service["nav_date"]
      end
      new_manifest.last_indexed_date = DateTime.now
      begin
        new_manifest.save
      rescue StandardError=>e
        LoggerHelper.log_error(e,manifest)
      end
      # elasticsearch has trouble with some metadata formating, so save it separately to catch issues without throwing away the entire manifest
      if service["metadata"]
        new_manifest.metadata = service["metadata"]
      end
      begin
        new_manifest.save
      rescue StandardError=>e
        LoggerHelper.log_error(e,manifest)
      end
    end
  end   

  def self.ingest_collection(collection)
    begin
      connection = open(collection, :allow_redirections => :safe)
    rescue Exception => e
      # get domain of manifest
      host = URI.parse(collection).host.downcase
      # open log file per domain
      File.open(host + ".log", "a") do |log|
        log.puts ("Can not open collection " + collection)
        log.puts "Error: #{e}"
      end
    else
      collection_json = connection.read
      begin
        service = IIIF::Service.parse(collection_json)
      rescue Exception => e
        LoggerHelper.log_error(e,collection)
      else
        # TODO add something to keep from reparsing an already included collection
        # you can have service.collections or service.manifests here 
        # if a collection, call this again
        service.collections.each do |collection|
        	puts("collection " + collection["@id"])
          new_collection = Collection.new
          new_collection.collection_id = collection['@id']
          new_collection.last_indexed_date = DateTime.now
          new_collection.save
        	ingest_collection(collection["@id"])
        end
        # if a manifest, call ingest_manifest
        service.manifests.each do |manifest|
        	puts("manifest " + manifest["@id"])
    		  CrawlerHelper.ingest_manifest(manifest["@id"])
        end
      end
	end
  end
end