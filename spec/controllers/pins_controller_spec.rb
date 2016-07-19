require 'spec_helper'
RSpec.describe PinsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    login(@user)
  end

  after(:each) do
    if !@user.destroyed?
      @user.destroy
    end
  end

  describe "GET index" do

    it 'renders the index template ' do
      get :index

      # expect(actual).to matcher(expected)
      # expect(actual).not_to matcher(expected)
      expect(response).to render_template("index")

    end

    # We're only supposed to see pins of logged-in user, right?

    #it 'populates @pins with all pins' do
    #  get :index
    #  expect(assigns[:pins]).to eq(Pin.all)
    #end

    it "redirects to login if user is not signed in" do
      logout(@user)
      get :index
      expect(response).to redirect_to(:login)
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

    it 'assigns an instance variable to a new pin' do
      get :new
      expect(assigns(:pin)).to be_a_new(Pin)
    end
    
    it "redirects to login if user is not signed in" do
      logout(@user)
      get :new
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST create" do
    before(:each) do
      @pin_hash = {
        title: "Rails Wizard",
        url: "http://railswizard.org",
        slug: "rails-wizard",
        text: "A fun and helpful Rails Resource",
        category_id: "2"} 
    end

    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end

    it 'responds with a redirect' do
      post :create, pin: @pin_hash
      expect(response.redirect?).to be(true)
    end

    it 'creates a pin' do
      post :create, pin: @pin_hash
      expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
    end

    it 'redirects to the show view' do
      post :create, pin: @pin_hash
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end

    it 'redisplays new form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(response).to render_template(:new)
    end

    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(assigns[:errors].present?).to be(true)
    end
    
    it "redirects to login if user is not signed in" do
      logout(@user)
      get :create
      expect(response).to redirect_to(:login)
    end

  end

  describe "GET edit" do
    before(:each) do
      # simple setup.  Test var is the general assembly pin I think.
      @pin = Pin.find(5)
    end

    it 'responds with success' do
      # should not result in any errors...
      get :edit, id: @pin.id
      expect(response.success?).to be(true)
    end

    it 'renders the edit template' do
      # we should wind up with the edit template
      get :edit, id: @pin.id
      expect(response).to render_template(:edit)
    end
    
    it 'assigns an instance variable called @pin to the Pin with the appropriate id' do
      # after the edit, the updated pin should be assinged to the pin
      # we started with, the one with the same :id
      get :edit, id: @pin.id
      expect(assigns(:pin)).to eq(@pin)
    end
    
    it "redirects to login if user is not signed in" do
      logout(@user)
      get :edit, id: @pin.id
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST update" do
  before(:each) do
    @pin = Pin.find(4)
    @pin_hash = {
      title: "Ruby Quiz",
      category_id: "1",
      url: "http://rubyquiz.com",
      text: "A collection of quizzes on the Ruby programming language.",
      slug: "ruby-quiz"
    }
    @error_hash = {
      title: nil,
      category_id: nil,
      url: nil,
      text: 8,
      slug: nil
    }
  end
    # These 3 tests  will test our update function with *no* errors...
    it 'responds with success' do
      put :update, id: @pin.id, pin: @pin_hash
      expect(response).to redirect_to("/pins/#{@pin.id}")
    end

    it 'updates a pin' do
      put :update, id: @pin.id, pin: @pin_hash
      expect(Pin.find(@pin.id).title).to eq(@pin_hash[:title])
    end

    it 'redirects to the show view' do
      put :update, id: @pin.id, pin: @pin_hash
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end

    # These 2 tests will test our update function *with errors*...
    it 'assigns an @errors instance variable' do
      put :update, id: @pin.id, pin: @error_hash
      expect(assigns[:errors].present?).to be(true)
    end

    it 'renders the edit view' do
      put :update, id: @pin.id, pin: @error_hash
      expect(response).to render_template(:edit)
    end
    
    it "redirects to login if user is not signed in" do
      logout(@user)
      put :update, id: @pin.id, pin: @pin_hash
      expect(response).to redirect_to(:login)
    end

  end

end

