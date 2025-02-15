class DriversController < ApplicationController
  def index
    @drivers = Driver.all
  end
  
  def show
    driver_id = params[:id].to_i
    @driver = Driver.find_by(id: driver_id)
    
    if @driver.nil?
      head :not_found
      return
    end
  end
  
  def new
    @driver = Driver.new
  end
  
  def create
    @driver = Driver.new(driver_params)
    @driver.active = true
    
    if @driver.save
      redirect_to driver_path(@driver.id)
      return
    else 
      render :new
      return 
    end
  end
  
  
  def edit
    driver_id = params[:id].to_i
    @driver = Driver.find_by(id: driver_id)
    
    if @driver.nil?
      redirect_to drivers_path
      return
    end
  end
  
  def update
    driver_id = params[:id].to_i
    @driver = Driver.find_by(id: driver_id)
    
    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(driver_params)
      redirect_to driver_path(@driver.id)
      return
    else
      render :edit
      return
    end
  end
  
  def destroy
    driver_id = params[:id].to_i
    @driver = Driver.find_by(id: driver_id)
    
    if @driver.nil?
      head :not_found
      return
    else
      @driver.destroy
      redirect_to drivers_path
      return
    end
  end
  
  def toggle_active
    driver_id = params[:id].to_i
    @driver = Driver.find_by(id: driver_id)
    
    if @driver.active
      @driver.go_offline
    else
      @driver.go_online
    end
    
    if @driver.active
      redirect_back(fallback_location: driver_path(driver_id))
      return
    else
      redirect_back(fallback_location: driver_path(driver_id), flash: { error: "Could not save completion date" })
      return
    end
  end
  
  private
  
  def driver_params
    if !params[:driver].nil?
      return params.require(:driver).permit(:name, :vin, :active, :car_make, :car_model)
    else
      return nil
    end
  end
  
end
