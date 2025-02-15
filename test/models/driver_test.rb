require "test_helper"

describe Driver do
  let (:new_driver) {Driver.new(name: "Kari", vin: "123", active: true, car_make: "Cherry", car_model: "DR5")}
  
  it "can be instantiated" do
    # Assert
    expect(new_driver.valid?).must_equal true
  end
  
  it "will have the required fields" do
    # Arrange
    new_driver.save
    driver = Driver.first
    [:name, :vin, :active, :car_make, :car_model].each do |field|
      
      # Assert
      expect(driver).must_respond_to field
    end
  end
  
  describe "relationships" do
    it "can have many trips" do
      # Arrange
      new_driver.save
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
      
      # Assert
      expect(new_driver.trips.count).must_equal 2
      new_driver.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end
  
  describe "validations" do
    it "must have a name" do
      # Arrange
      new_driver.name = nil
      
      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :name
      expect(new_driver.errors.messages[:name]).must_equal ["can't be blank"]
    end
    
    it "must have a VIN number" do
      # Arrange
      new_driver.vin = nil
      
      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :vin
      expect(new_driver.errors.messages[:vin]).must_equal ["can't be blank"]
    end
  end
  
  # Tests for methods you create should go here
  describe "custom methods" do
    
    describe "average rating" do
      it "can calculate the average rating of multiple trips" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # create a passenger for the trips
        passenger = Passenger.create(name: "Nina", phone_num: "560.815.3059")
        # create two trips
        trip_one = Trip.create(date: Date.current, rating: 5, cost: 1200, driver_id: driver.id, passenger_id: passenger.id)
        trip_two = Trip.create(date: Date.current, rating: 3, cost: 1400, driver_id: driver.id, passenger_id: passenger.id)
        
        # assert
        expect(driver.average_rating).must_equal 4
      end
      
      it "can calculate the average rating of one trip" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # create a passenger for the trips
        passenger = Passenger.create(name: "Nina", phone_num: "560.815.3059")
        # create two trips
        trip_one = Trip.create(date: Date.current, rating: 5, cost: 1200, driver_id: driver.id, passenger_id: passenger.id)
        
        # assert
        expect(driver.average_rating).must_equal 5
      end
      
      it "can calculate the average rating of multiple trips where one is not rated" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # create a passenger for the trips
        passenger = Passenger.create(name: "Nina", phone_num: "560.815.3059")
        # create two trips
        trip_one = Trip.create(date: Date.current, rating: 5, cost: 1200, driver_id: driver.id, passenger_id: passenger.id)
        trip_two = Trip.create(date: Date.current, rating: nil, cost: 1200, driver_id: driver.id, passenger_id: passenger.id)
        
        # assert
        expect(driver.average_rating).must_equal 5
      end
      
      it "returns nil for a driver with no trips" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # assert
        expect(driver.average_rating).must_be_nil
      end
    end
    
    describe "total earnings" do
      it "can calculate the total earnings for multiple trips" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # create a passenger for the trips
        passenger = Passenger.create(name: "Nina", phone_num: "560.815.3059")
        # create two trips
        trip_one = Trip.create(date: Date.current, rating: 5, cost: 1200, driver_id: driver.id, passenger_id: passenger.id)
        trip_two = Trip.create(date: Date.current, rating: 3, cost: 1400, driver_id: driver.id, passenger_id: passenger.id)
        
        # assert
        expect(driver.total_earnings).must_equal 2600
      end
      
      it "can calculate the total earnings for one trip" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # create a passenger for the trips
        passenger = Passenger.create(name: "Nina", phone_num: "560.815.3059")
        # create two trips
        trip_one = Trip.create(date: Date.current, rating: 5, cost: 1200, driver_id: driver.id, passenger_id: passenger.id)
        
        # assert
        expect(driver.total_earnings).must_equal 1200
      end
      
      it "returns 0 for a driver with no trips" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # assert
        expect(driver.total_earnings).must_equal 0
      end
    end
    
    describe "driver earnings" do
      it "can calculate the driver's earnings for multiple trips" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # create a passenger for the trips
        passenger = Passenger.create(name: "Nina", phone_num: "560.815.3059")
        # create two trips
        trip_one = Trip.create(date: Date.current, rating: 5, cost: 1200, driver_id: driver.id, passenger_id: passenger.id)
        trip_two = Trip.create(date: Date.current, rating: 3, cost: 1400, driver_id: driver.id, passenger_id: passenger.id)
        
        # 1200 + 1400 = 2600
        # 2600 - 165 = 2435
        # 2435 * 0.8 = 1948
        
        # assert
        expect(driver.driver_earnings).must_equal 1948
      end
      
      it "can calculate the driver's earnings for one trip" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # create a passenger for the trips
        passenger = Passenger.create(name: "Nina", phone_num: "560.815.3059")
        # create two trips
        trip_one = Trip.create(date: Date.current, rating: 5, cost: 1200, driver_id: driver.id, passenger_id: passenger.id)
        
        # 1200 - 165 = 1035
        # 1035 * 0.8 = 828
        
        # assert
        expect(driver.driver_earnings).must_equal 828
      end
      
      it "returns 0 for a driver with no trips" do
        # arrange
        driver = Driver.create(name: "Kari", vin: "123")
        # assert
        expect(driver.driver_earnings).must_equal 0
      end
    end
    
    describe "can go online" do
      it "makes active true if it is false" do
        # arrange
        driver = Driver.create(name: "Micky", vin: "777", active: false)
        driver_id = driver.id
        
        # act
        driver.go_online
        
        updated_driver = Driver.find_by(id: driver_id)
        
        # assert
        expect(updated_driver.active).must_equal true
      end
      
      it "should be idempotent" do
        # arrange
        driver = Driver.create(name: "Micky", vin: "777", active: false)
        driver_id = driver.id
        
        # act
        driver.go_online
        driver.go_online
        
        updated_driver = Driver.find_by(id: driver_id)
        
        # assert
        expect(updated_driver.active).must_equal true
      end
      
    end
    
    describe "can go offline" do
      it "makes active false if it is true" do
        # arrange
        driver = Driver.create(name: "Micky", vin: "777", active: true)
        driver_id = driver.id
        
        # act
        driver.go_offline
        
        updated_driver = Driver.find_by(id: driver_id)
        
        # assert
        expect(updated_driver.active).must_equal false
      end
      
      it "should be idempotent" do
        # arrange
        driver = Driver.create(name: "Micky", vin: "777", active: true)
        driver_id = driver.id
        
        # act
        driver.go_offline
        driver.go_offline
        
        updated_driver = Driver.find_by(id: driver_id)
        
        # assert
        expect(updated_driver.active).must_equal false
      end
    end
    
    # You may have additional methods to test
    describe "get driver" do
      it "should select the first available driver" do
        unavailable_driver = Driver.create(name: "I am unavailable", vin: "unavailable", active: false)
        driver1 = Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9", active: true)
        driver2 = Driver.create(name: "available driver", vin: "13245", active: true)
        
        selected_driver = Driver.get_driver
        
        expect(selected_driver).must_be_instance_of Driver
        expect(selected_driver.name).must_equal driver1.name
        expect(selected_driver.vin).must_equal driver1.vin
        expect(selected_driver.active).must_equal false
      end
      
      it "should return nil if there are no inactive drivers" do
        unavailable_driver = Driver.create(name: "I am unavailable", vin: "unavailable", active: false)
        
        selected_driver = Driver.get_driver
        
        expect(selected_driver).must_be_nil
      end
    end
    
    describe "avatar image" do
      it "must return an image link" do
        driver = Driver.create(name: "M. Random", vin: "88888888", active: false)
        
        avatar_url = driver.avatar_image
        
        url_beginning = !!(avatar_url =~ /\Ahttps:\/\//)
        url_ending = !!(avatar_url =~ /\.png\Z/)
        
        expect(url_beginning).must_equal true
        expect(url_ending).must_equal true
      end
    end
    
  end
end
