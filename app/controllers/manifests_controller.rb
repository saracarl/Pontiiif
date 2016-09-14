class ManifestsController < ApplicationController
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

    # GET /manifests/search
  def search
    @manifests = Manifest.all

    render action: "search"
  end

  # GET /manifests/search
  def searchresults
    #binding.pry
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manifest
      @manifest = Manifest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manifest_params
      params.require(:manifest).permit(:manifest_id, :label, :description, :license, :navDate)
    end
end
