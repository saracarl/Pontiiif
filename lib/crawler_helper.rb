module CrawlerHelper
  
  def self.ingest_manifest(manifest)
  	connection = open(manifest, :allow_redirections => :safe)
    manifest_json = connection.read
    begin
	    service = IIIF::Service.parse(manifest_json)
	rescue StandardError=>e
		# get domain of manifest
		host = URI.parse(manifest).host.downcase
		# open log file per domain
		File.open(host + ".log", "a") do |log|
			log.puts (manifest + " manifest is incorrectly formatted")
			log.puts "Error: #{e}"
		end
	else
    new_manifest = Manifest.new
		new_manifest.manifest_id = service['@id']
    new_manifest.label = service.label
    	if service.description
	    	new_manifest.description = service.description
    	end
    	if service.license
	    	new_manifest.license = service.license
	    end
    	if service["navDate"]
    		new_manifest.navDate = service["nav_date"]
    	end
      new_manifest.save
	end
  end

  def self.ingest_collection(collection)
  	connection = open(collection)
    collection_json = connection.read
    service = IIIF::Service.parse(collection_json)
    # TODO add the below back in to keep from reparsing an already included collection
    # you can have service.collections or service.manifests here 
    # if a collection, call this again
    service.collections.each do |collection|
    	puts("this is collection " + collection["@id"])
    	ingest_collection(collection["@id"])
    end
    # if a manifest, call ingest_manifest
    service.manifests.each do |manifest|
    	puts("this is manifest " + manifest["@id"])
		CrawlerHelper.ingest_manifest(manifest["@id"])
	end
  end
end