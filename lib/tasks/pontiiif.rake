require 'open-uri'
require 'crawler_helper'

namespace :pontiiif do
  desc "ingest a manifest; produce keys"
  task :ingest, [:manifest] => :environment do |t, args|
  	CrawlerHelper.ingest_manifest(args.manifest)
  end

  desc "crawl all manifests in a collection; produce keys"
  task :ingest_collection, [:collection] => :environment do |t, args|
  	CrawlerHelper.ingest_collection(args.collection)
  end

  desc "populate collections to be crawled from IIIF-Universe"
  task :populate_from_universe => :environment do
      CrawlerHelper.populate_from_universe    
  end

  desc "populate collections to be crawled from IIIF-Universe"
  task :crawl_collections => :environment do
    Collection.all.each do |collection|
      CrawlerHelper.ingest_collection(collection.collection_id)
    end
  end


end
