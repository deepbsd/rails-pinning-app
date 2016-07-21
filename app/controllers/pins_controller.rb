class PinsController < ApplicationController

  before_action :require_login, except: [:show, :show_by_name]  

  def index
    @pins = Pin.all
    #@pins = current_user.pins
  end

  def new
    @pin = Pin.new
  end

  def create
    @pin = Pin.create(pin_params)
    if @pin.valid?
      @pin.save
      redirect_to pin_path(@pin)
    else
      @errors = @pin.errors
      render :new
    end
  end

  def edit
    @pin = Pin.find(params[:id])
    render :edit
  end

  def update
    @pin = Pin.update(params[:id], pin_params)
    if @pin.valid?
      @pin.save
      redirect_to pin_path(@pin)
    else
      @errors = @pin.errors
      render :edit
    end
  end
  
  def show
    @pin = Pin.find(params[:id])
    # populate @users with all users who have pinned this pin
    @users = User.joins(:pinnings).where("users.id = ? or pinnings.pin_id = ?", @pin.user_id, @pin.id).distinct
  end

  def show_by_name
    @pin = Pin.find_by_slug(params[:slug])
    @users = User.joins(:pinnings).where("users.id = ? or pinnings.pin_id = ?", @pin.user_id, @pin.id).distinct
    render :show
  end

  def repin
    @pin = Pin.find(params[:id])
    @pin.pinnings.create(user: current_user)
    redirect_to user_path(current_user)
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image, :user_id)
  end

end
