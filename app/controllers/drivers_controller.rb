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
    params = driver_params
    if !params.nil?
      @driver = Driver.new(params)
      
      if @driver.save
        redirect_to driver_path(@driver.id)
        return
      end
    end
    redirect_to new_driver_path
    return 
  end
  
  private
  
  def driver_params
    if !params[:driver].nil?
      return params.require(:driver).permit(:name, :vin)
    else
      return nil
    end
  end
  
end
