require 'spec_helper'
RSpec.describe BoardsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @board = @user.boards.first
    login(@user)
  end
  after(:each) do
    if !@user.destroyed?
      @user.pins.destroy_all
      @user.boards.destroy_all
      @user.destroy
    end
  end

  describe "GET new" do
  
    it 'responds with successfully' do
      get :new
      expect(response.success?).to be(true)
    end

    it 'renders the new view' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns an instance variable to a new board' do
      get :new
      expect(assigns(:board)).to be_a_new(Board)
    end

    it 'redirects to the login page if user is not logged in' do
      logout(@user)
      get :new
      expect(response).to redirect_to(:login)
    end

  end

  describe "POST create" do

    before(:each) do
      @board_hash = {
        name: "Test Pins!"
       }
    end

    after(:each) do
      board = Board.find_by_name("Test Pins!")
      if !board.nil?
        board.destroy
      end
    end

    it 'responds with a redirect' do
      post :create, board: @board_hash
      expect(response.redirect?).to be(true)
    end

    it 'creates a board' do
      post :create, board: @board_hash
      expect(Board.find_by_name("Test Pins!").present?).to be(true)
    end

    it 'redirects to the show view' do
      post :create, board: @board_hash
      expect(response).to redirect_to(board_url(assigns(:board)))
    end

    it 'redisplays new form on error' do
      # The name is required in the Board model, so we'll make the
      # name nil to test what happens with invalid parameters
      @board_hash[:name] = nil
      post :create, board: @board_hash
      expect(response).to render_template(:new)
    end
    
    it 'redirects to the login page if user is not logged in' do
      logout(@user)
      post :create, board: @board_hash
      expect(response).to redirect_to(:login)
    end
  end

  describe "GET #show" do

    it "assigns the requested board" do
      get :show, {:id => @board.to_param}
      expect(assigns(:board)).to eq(@board)
    end

    it "assigns the @pins variable with the board's pins" do
      get :show, {:id => @board.to_param}
      expect(assigns(:pin)).to eq(@pin)
    end
  end

end
