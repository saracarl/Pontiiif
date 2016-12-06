require 'elasticsearch/dsl'
require 'crawler_helper'

class ManifestsController < ApplicationController
  include Elasticsearch::DSL
  #before_action :set_manifest, only: [:show, :edit, :update, :destroy]

  # GET /manifests
  # GET /manifests.json
  def index
    @manifests = Manifest.all
  end

  # GET /manifests/1
  # GET /manifests/1.json
  def show
  end

  # GET /manifests/new
  def new
    @manifest = Manifest.new
  end

  # GET /manifests/1/edit
  def edit
  end

    #GET /manifests/search
   def search
     render action: "search"
   end

  def addcollection
    rake_call = "rake pontiiif:ingest_collection[" + params[:collection] +"]  --trace 2>&1 >> rake_log.log &"
    logger.info rake_call
    system(rake_call)
    render action: "addedcollection"
  end

  def advanced_search
    query = {size: 0, aggs: {licenses: {terms: { field: "license" }}}}
    @query_results = Manifest.search(query)
    @licenses = @query_results.response["aggregations"]["licenses"]["buckets"].map { |h| h["key"] }
  end

  def advancedsearch
    must_array=[]
    if !params["label"].blank? then 
      label_match = {match: {label: params["label"]}} 
      must_array << label_match 
    end
    if !params["description"].blank? then 
      description_match = {match: {description: params["description"]}} 
      must_array << description_match
    end
    # if just a startDate, treat it as starting on jan 1 and going through the year
    # if just an endDate, same
    # if both...
    if !params["startDate"].blank? && !params["endDate"].blank? then
      startTime = Time.new(params["startDate"]).utc
      endTime = Time.new(params["endDate"]).utc
      endTime=endTime+1.year
      date_range = {range: {nav_date: {gte: startTime, lte: endTime}}} 
      must_array << date_range
    end
    #startDate no endDate
    if !params["startDate"].blank? && params["endDate"].blank? then
      startTime = Time.new(params["startDate"]).utc
      date_range = {range: {nav_date: {gte: startTime}}} 
      must_array << date_range
    end
    #endDate no startDate
    if params["startDate"].blank? && !params["endDate"].blank? then
      endTime = Time.new(params["endDate"]).utc
      endTime=endTime+1.year
      date_range = {range: {nav_date: {lte: endTime}}} 
      must_array << date_range
    end
    if !params["metadata"].blank? then 
      metadata_match = {match: {metadata: params["metadata"]}} 
      must_array << metadata_match
    end
    if !params["license"]["license_id"].blank? then 
      license_match = {match: {license: params["license"]["license_id"]}} 
      must_array << license_match
    end
    bool_clause = {bool: {must: must_array}}
    query = {query: bool_clause}
    @manifests = Manifest.search(query)
    render action: "index"
  end

  # GET /manifests/search
  def searchresults
    @manifests = Manifest.search(params[:q])
    render action: "index"
  end

  # POST /manifests
  # POST /manifests.json
  def create
    @manifest = Manifest.new(manifest_params)

    respond_to do |format|
      if @manifest.save
        format.html { redirect_to @manifest, notice: 'Manifest was successfully created.' }
        format.json { render :show, status: :created, location: @manifest }
      else
        format.html { render :new }
        format.json { render json: @manifest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manifests/1
  # PATCH/PUT /manifests/1.json
  def update
    respond_to do |format|
      if @manifest.update(manifest_params)
        format.html { redirect_to @manifest, notice: 'Manifest was successfully updated.' }
        format.json { render :show, status: :ok, location: @manifest }
      else
        format.html { render :edit }
        format.json { render json: @manifest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manifests/1
  # DELETE /manifests/1.json
  def destroy
    @manifest.destroy
    respond_to do |format|
      format.html { redirect_to manifests_url, notice: 'Manifest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def api_search
    @manifests = Manifest.search(params[:query])
    collection = IIIF::Presentation::Collection.new
    collection['@id'] = api_search_path({:query => params[:query], :only_path => false})
    collection.label = "IIIF resources discovered by searching the Pontiiif installation at for '#{params[:query]}' at #{Time.now}"
    
    @manifests.each do |db_manifest|
      seed = { 
        '@id' => db_manifest.manifest_id, 
        'label' => db_manifest.label,
        'description' => db_manifest.description
      }
      manifest = IIIF::Presentation::Manifest.new(seed)
      manifest.metadata = db_manifest.metadata if db_manifest.metadata
      manifest.thumbnail = db_manifest.thumbnail if db_manifest.thumbnail  
      manifest.license = db_manifest.license if db_manifest.license
      
      collection.manifests << manifest 
    end

    render :text => collection.to_json(pretty: true), :content_type => "application/json"

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manifest
      @manifest = Manifest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manifest_params
      params.require(:manifest).permit(:manifest_id, :label, :description, :license, :nav_date)
    end
end
