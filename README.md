# Pontiiif: a Search Engine for IIIF Discovery.
IIIF Discovery web crawler and ElasticSearch backed search engine

As the IIIF community grows, discoverability is becoming essential.  We propose a general purpose search engine for IIIF content that can be integrated easily into IIIF client applications.

## Technical Specifications
###Search
Users will be able to search within labels, descriptions, and metadata from collections and manifests and will be able to restrict search results by license and language of description. 

The HTML user interface will list titles of documents as well as the draggable IIIF icon for each manifest in the result set.
###Crawler
Pontiiif will update its database on a nightly basis by crawling all collections on the IIIF Universe. It will ingest titles and metadata from collections and manifests, storing them in its datastore.  It will not ingest data from annotationLists attached to manifests.

A basic web form will allow collection manifests not in the IIIF-Universe GitHub repository to be added for nightly crawling.
###Infrastructure
Pontiiif will be written in Ruby on Rails, using the most appropriate technologies for storage and searching.  (Under consideration are ElasticSearch, Solr, or a straight database search using MongoDB.)  Osullivan will be used for IIIF crawling.  Scheduling will be handled by cron.

The code will be released under an Apache 2.0 license and published on GitHub. 

Funded by a IIIF comissioned implementation grant. 
