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
      if !service.label.kind_of? String
         new_manifest.label = JSON.parse(service.label.to_json.gsub("@",""))
      else
        new_manifest.label = service.label
      end
      new_manifest.thumbnail = service.thumbnail
      if service.description
        #binding.pry
        if !service.description.kind_of? String
         new_manifest.description = JSON.parse(service.description.to_json.gsub("@",""))
        else
          new_manifest.description = [{"value"=>service.description}]
        end
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
#        binding.pry
        new_manifest.metadata = expand_array(service["metadata"])
=begin        if !service["metadata"].kind_of? String
          new_manifest.metadata = service["metadata"].to_json.gsub("@","")
        else
          new_manifest.metadata = service["metadata"]
        end
=end
      end
      begin
        new_manifest.save
      rescue StandardError=>e
        LoggerHelper.log_error(e,manifest)
      end
    end
  end   

  def self.expand_element(complex_element)
    new_hashes = []
    clean_prototype = complex_element.reject{|k,v| v.is_a? Array}
    # invert the hash
    complex_element.invert.each_pair do |k,v|
      # for each key
      # p k
      if k.is_a? Array
        # if an array, then for each element
        k.each do |simple_hash|
          # append a new hash
          new_simple_hash = simple_hash.clone
          new_simple_hash[v] = simple_hash["@value"]
          new_simple_hash.delete("@value")
          new_hashes << new_simple_hash.merge(clean_prototype) 
        end
      end
    end
    new_hashes
  end

  def self.contains_array?(complex_element)
    complex_element.values.detect{|value| value.is_a? Array}
  end


  def self.contains_arrays_with_hashes?(complex_element)
    complex_element.values.detect{ |value| (value.is_a?(Array) && value.first.is_a?(Hash)) }    
  end

  def self.array_has_hashes?(array)
    array.detect{|value| value.is_a? Hash}
  end

  def self.consolidate_element(element)
    new_hash = {}
    element.each_pair do |k,v|
      if v.is_a? Array
        new_hash[k] = v.join(', ')
      else
        new_hash[k] = v
      end
    end
    new_hash
  end

  def self.expand_array(original_array)
    new_array = []
    original_array.each do |element|
      if contains_array?(element)
        if contains_arrays_with_hashes?(element)
          new_array += expand_element(element)
        else
          new_array << consolidate_element(element)
        end
      else 
        new_array << element
      end
    end
    new_array
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
