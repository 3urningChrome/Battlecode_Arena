class CompetitorsController < ApplicationController
  before_action :set_competitor, only: [:show, :edit, :update, :destroy]

  # GET /competitors
  # GET /competitors.json
  def index
    #@competitors = Competitor.all
    @competitors = Competitor.where("active = ?", true)
  end
  
  def index_inactive
     @competitors = Competitor.where.not("active = ?", true)
  end

  # GET /competitors/1
  # GET /competitors/1.json
  def show
    @games = Game.where("teamA LIKE ? OR teamB LIKE ?", @competitor.name, @competitor.name)
  end

  # GET /competitors/new
  def new
    @competitor = Competitor.new
    @competitor.team = "Anonymous"
  end

  # GET /competitors/1/edit
  def edit
  end

  # POST /competitors
  # POST /competitors.json
  def create
    @competitor = Competitor.new(competitor_params)
    @competitor.Elo = 1500
    @competitor.wins = 0
    @competitor.losses = 0
    @competitor.active = false
    @competitor.broken = false

    respond_to do |format|
      if @competitor.save
        format.html { redirect_to @competitor, notice: 'Competitor was successfully created.' }
        format.json { render :show, status: :created, location: @competitor }
      else
        format.html { render :new }
        format.json { render json: @competitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitors/1
  # PATCH/PUT /competitors/1.json
  def update
    respond_to do |format|
      if @competitor.update(competitor_params)
        format.html { redirect_to @competitor, notice: 'Competitor was successfully updated.' }
        format.json { render :show, status: :ok, location: @competitor }
      else
        format.html { render :edit }
        format.json { render json: @competitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitors/1
  # DELETE /competitors/1.json
  def destroy
    @competitor.destroy
    respond_to do |format|
      format.html { redirect_to competitors_url, notice: 'Competitor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competitor
      @competitor = Competitor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competitor_params
      params.require(:competitor).permit(:name, :team, :Elo, :active, :wins, :losses, :broken, :ai)
    end
end
