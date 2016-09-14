json.extract! manifest, :id, :manifest_id, :label, :description, :license, :navDate, :created_at, :updated_at
json.url manifest_url(manifest, format: :json)