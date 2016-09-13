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

end
