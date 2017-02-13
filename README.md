# Pontiiif: a Search Engine for IIIF Discovery.

As the IIIF community grows, discoverability has become essential.  Pontiiif is a general purpose search engine for IIIF content.

You can find Pontiiif at http://pontiiif.brumfieldlabs.com/ or you can install it on your own server.

Pontiiif is a IIIF commissioned implementation and does not have any ongoing support.  We welcome code contributions.

## What it does
Pontiiif crawls and indexes IIIF manifests starting at top level collection manifests.  It ingests labels, descriptions, navDates, licenses and metadata from collections and manifests, storing them in an ElasticSearch datastore.

Pontiiif also includes a web UI that allows simple searching across all indexed fields or advanced searching across specific indexed fields.

## What it doesn't do
Pontiiif does not ingest data from annotationLists or layers attached to manifests.

If we have any trouble parsing or storing the metadata field we skip the metadata but do store the rest of the manifest.  (Errors are logged.)

## Installation

1.  Clone the github repostitory:  `git clone https://github.com/saracarl/Pontiiif.git`
2.  Install ElasticSearch.  Pontiiif has been tested against versions 2.3.3 and 2.4.1 and will likely work against any higher versions as well.
3.  Start ElasticSearch
4.  Create the ElasticSearch index and analyzers:  `cd HOME/$Pontiiif; curl -XPUT 'http://localhost:9200/manifests/' -d @recreate_index_with_analyzer_and_fields.json` 
5.  Install Rails 4
6.  `cd $HOME/Pontiiif; bundle install`
7.  Add the application to your apache config.
8.  Verify the web interface is up and running.
9.  Run the rake task to ingest your collection  (we recommend creating a cron job if you want this to run on a regular basis)  rake pontiiif:ingest_collection[https://raw.githubusercontent.com/ryanfb/iiif-universe/gh-pages/iiif-universe.json]
10. Check the ingestion logs in the "logs" tab in the app or the tmp/logs directory.

A PontIIIF server should call `rake pontiiif:crawl_collections` on a regular basis (e.g. a weekly cron job) to refresh its search index.  This rake task will recursively crawl all collections stored by the PontIIIF server.


## How to Contribute
There's lots more to be done.  If you find a problem or have a suggestion, please open an issue.  We welcome code changes in the form of pull requests, too!

### Opening a new issue

1. Look through [the existing issues](https://github.com/saracarl/Pontiiif/issues) to see if your issue already exists.
2. If your issue already exists, comment on its thread with any information you have. Even if this is simply to note that you are having the same problem, it is still helpful!
3. Always *be as descriptive as you can*.
4. What is the expected behavior? What is the actual behavior? What are the steps to reproduce?
5. Attach screenshots, videos, GIFs if possible.

### Submitting a pull request

1. Find an issue to work on, or create a new one. *Avoid duplicates, please check existing issues!*
2. Fork the repo, or make sure you are synced with the latest changes on `develop`.
3. Create a new branch with a sweet name: `git checkout -b issue_<##>_<description>`.
4. Do some programming
5. Submit a pull request to the `develop` branch (please resolve any conflicts before submitting the pull request).

**You should submit one pull request per feature!** The smaller the PR, the easier it is for us to review it and merge it in. 

## License

Copyright 2016 Brumfield Labs, LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

