
class TripsController < ApplicationController
  
  def show
    @trip = Trip.find_by(id: params[:id])
    
    if @trip.nil?
      head :not_found
      return
    end
  end
  
  def create
    passenger_trips = Trip.where(passenger_id: params[:passenger_id])
    
    passenger_trips.each do |trip|
      if trip.rating == nil
        flash[:notice] = "You may only request a trip after your previous one has completed and you rate it."
        redirect_to passenger_path(params[:passenger_id])
        return
      end
    end
    
    driver = Driver.get_driver
    
    if driver == nil
      flash[:notice] = "There are no available drivers."
      redirect_to passenger_path(params[:passenger_id])
      return
    end
    
    date = DateTime.now
    
    # all costs are four digits ($10.00-$99.99)
    cost = rand(1000..9999).to_i
    
    data_hash = {
    date: date,
    driver_id: driver.id,
    passenger_id: params[:passenger_id],
    rating: nil,
    cost: cost,
  }
  
  @trip = Trip.new(data_hash)
  
  if @trip.save
    redirect_to passenger_path(@trip.passenger_id)
    return
  else
    redirect_to root_path
    return
  end
end

def edit
  @trip = Trip.find_by(id: params[:id])
  
  if @trip.nil?
    redirect_to root_path
    return
  end
end

def update
  @trip = Trip.find_by(id: params[:id])
  
  if @trip.nil?
    head :not_found
    return
  end
  
  if params[:trip][:driver_name].blank? || params[:trip][:passenger_name].blank? || params[:trip][:cost].blank?
    prev = Rails.application.routes.recognize_path(request.referrer)
    if (prev[:action] == "rate" || prev[:action] == "show") && params[:action] != "edit" && prev[:action] != "edit"
      @trip.rating = params[:trip][:rating]
      if @trip.save
        redirect_to trip_path(@trip.id)
        return
      else
        flash[:notice] = "Unable to save rating."
        redirect_to rate_path(params[:id])
        return
      end
    else
      flash[:notice] = "You must enter a value for all fields."
      redirect_to edit_trip_path(params[:id])
      return
    end
  end 
  
  driver = Driver.find_by(name: params[:trip][:driver_name])
  passenger = Passenger.find_by(name: params[:trip][:passenger_name])
  
  if driver.nil? 
    flash[:notice] = "This driver is not in our system."
    redirect_to edit_trip_path(params[:id])
    return
  end
  
  if passenger.nil?
    flash[:notice] = "This passenger is not in our system."
    redirect_to edit_trip_path(params[:id])
    return
  end
  
  @trip.driver_id = driver.id
  @trip.passenger_id = passenger.id
  
  if @trip.update(trip_params)
    redirect_to trip_path(@trip.id)
    return
  else
    redirect_to edit_trip_path(params[:id])
    return
  end
end

def destroy
  trip_id = params[:id].to_i
  @trip = Trip.find_by(id: trip_id)
  
  if @trip.nil?
    head :not_found
    return
  else
    @trip.destroy
    redirect_to root_path
    return
  end
end

def rate
  @trip = Trip.find_by(id: params[:id])
  
  if @trip.nil?
    redirect_to root_path
    return
  end
end

private

def trip_params
  return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
end

end
