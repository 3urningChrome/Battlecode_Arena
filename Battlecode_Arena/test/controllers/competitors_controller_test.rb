require 'test_helper'

class CompetitorsControllerTest < ActionController::TestCase
  setup do
    @competitor = competitors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:competitors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create competitor" do
    assert_difference('Competitor.count') do
      post :create, competitor: { Elo: @competitor.Elo, active: @competitor.active, broken: @competitor.broken, losses: @competitor.losses, name: @competitor.name, team: @competitor.team, wins: @competitor.wins }
    end

    assert_redirected_to competitor_path(assigns(:competitor))
  end

  test "should show competitor" do
    get :show, id: @competitor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @competitor
    assert_response :success
  end

  test "should update competitor" do
    patch :update, id: @competitor, competitor: { Elo: @competitor.Elo, active: @competitor.active, broken: @competitor.broken, losses: @competitor.losses, name: @competitor.name, team: @competitor.team, wins: @competitor.wins }
    assert_redirected_to competitor_path(assigns(:competitor))
  end

  test "should destroy competitor" do
    assert_difference('Competitor.count', -1) do
      delete :destroy, id: @competitor
    end

    assert_redirected_to competitors_path
  end
end
