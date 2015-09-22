class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all.order(:updated_at).reverse_order
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @competitors = Competitor.where("full_name = ? OR full_name = ?", @game.full_name_a, @game.full_name_b)
  end

  # GET /games/new
  def new
    @game = Game.new
    @maps = Map.all.order(:name)
    @competitors= Competitor.where("active = ?", true).order(:created_at).reverse_order
  end

  # GET /games/1/edit
  def edit
    @maps = Map.all.order(:name)
    @competitors= Competitor.where("active = ?", true).order(:created_at).reverse_order  
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    
    respond_to do |format|
      begin
        if @game.save
          format.html { redirect_to @game, notice: 'Game was successfully created.' }
          format.json { render :show, status: :created, location: @game }
        else
          format.html { render :new }
          format.json { render json: @game.errors, status: :unprocessable_entity }
          @maps = Map.all.order(:name)
          @competitors= Competitor.where("active = ?", true).order(:created_at).reverse_order
        end
      rescue ActiveRecord::RecordNotUnique
        @game.errors.add(:teamb, "Game Already Exists between these Competitors")
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
        @maps = Map.all.order(:name)
        @competitors= Competitor.where("active = ?", true).order(:created_at).reverse_order
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
#  def match_rms
#    send_file(
#      "#{Rails.root}/public/downloads/game/#{params[:game_file_path]}/match.rms",
#      filename: "match.rms",
#      type: "application/rms"
#    )
#  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:team, :teama, :teamb, :map, :turns, :scorea, :scoreb, :winner, :loser, :file)
    end
end
