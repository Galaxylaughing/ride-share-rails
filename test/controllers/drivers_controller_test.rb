require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.
  let(:driver) {
    Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9", car_make: "fake car", car_model: "fake car")
  }
  
  describe "index" do
    it "responds with success when there are many drivers saved" do
      # Arrange
      # Ensure that there is at least one Driver saved
      
      # Act
      get drivers_path
      # Assert
      must_respond_with :success
    end
    
    it "responds with success when there are no drivers saved" do
      # Arrange
      # Ensure that there are zero drivers saved
      driver_list = Driver.all
      expect(driver_list.blank?).must_equal true
      
      # Act
      get drivers_path
      # Assert
      must_respond_with :success
    end
  end
  
  describe "show" do
    it "responds with success when showing an existing valid driver" do
      # Arrange
      # Ensure that there is a driver saved
      
      # Act
      get driver_path(driver.id)
      # Assert
      must_respond_with :success
    end
    
    it "responds with 404 with an invalid driver id" do
      # Arrange
      # Ensure that there is an id that points to no driver
      
      # Act
      get driver_path(-1)
      # Assert
      must_respond_with :not_found
    end
  end
  
  describe "new" do
    it "responds with success" do
      # Act
      get new_driver_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      data_hash = {
        driver: {
          name: "Micky Mouse",
          vin: "777"
        }
      }
      
      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect {
        post drivers_path, params: data_hash
      }.must_change 'Driver.count', 1
      
      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
      new_driver = Driver.find_by(name: data_hash[:driver][:name])
      expect(new_driver.name).must_equal data_hash[:driver][:name]
      expect(new_driver.vin).must_equal data_hash[:driver][:vin]
      expect(new_driver.active).must_equal true
      
      must_redirect_to driver_path(new_driver.id)
    end
    
    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations
      data_hash = {}
      
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        post drivers_path, params: data_hash
      }.wont_change 'Driver.count'
      
      # Assert
      # Check that the controller redirects
      assert_template :new
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      # Arrange
      # Ensure there is an existing driver saved
      
      # Act
      get edit_driver_path(driver.id)
      # Assert
      must_respond_with :success
    end
    
    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      
      # Act
      get edit_driver_path(-1)
      # Assert
      must_redirect_to drivers_path
    end
  end
  
  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved
      driver = Driver.create(name: "Micky", vin: "777")
      # Assign the existing driver's id to a local variable
      driver_id = driver.id
      # Set up the form data
      data_hash = {
        driver: {
          name: "Minnie",
          vin: "888"
        }
      }
      
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(driver_id), params: data_hash
      }.wont_change "Driver.count"
      
      # Assert
      # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated
      updated_driver = Driver.find_by(id: driver_id)
      expect(updated_driver.name).must_equal data_hash[:driver][:name]
      expect(updated_driver.vin).must_equal data_hash[:driver][:vin]
      
      # Check that the controller redirected the user
      must_redirect_to driver_path(updated_driver.id)
    end
    
    it "does not update any driver if given an invalid id, and responds with a 404" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      invalid_id = -1
      # Set up the form data
      data_hash = {
        driver: {
          name: "Minnie",
          vin: "888"
        }
      }
      
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(invalid_id), params: data_hash
      }.wont_change "Driver.count"
      
      # Assert
      # Check that the controller gave back a 404
      must_respond_with :not_found
    end
    
    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing driver saved
      driver = Driver.create(name: "Micky", vin: "777")
      # Assign the existing driver's id to a local variable
      driver_id = driver.id
      # Set up the form data so that it violates Driver validations
      data_hash = {
        driver: {
          name: nil,
          vin: "888"
        }
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(driver_id), params: data_hash
      }.wont_change 'Driver.count'
      # Assert
      # Check that the controller redirects
      assert_template :edit
    end
  end
  
  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      # Ensure there is an existing driver saved
      wrong_driver = Driver.create(name: "Micky", vin: "777")
      wrong_driver_id = wrong_driver.id
      
      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count
      expect {
        delete driver_path(wrong_driver_id)
      }.must_change "Driver.count", -1
      
      # Assert
      deleted_driver = Driver.find_by(id: wrong_driver_id)
      expect(deleted_driver).must_be_nil
      # Check that the controller redirects
      must_redirect_to drivers_path
    end
    
    it "does not change the db when the driver does not exist, then responds with " do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      invalid_id = -1
      
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        delete driver_path(invalid_id)
      }.wont_change "Driver.count"
      
      # Assert
      # Check that the controller responds or redirects with whatever your group decides
      must_respond_with :not_found
    end
  end
  
  describe "toggle active" do
    it "makes active true if it is false" do
      # arrange
      driver = Driver.create(name: "Micky", vin: "777", active: false)
      driver_id = driver.id
      
      # act
      patch toggle_active_path(driver_id)
      
      updated_driver = Driver.find_by(id: driver_id)
      
      # assert
      expect(updated_driver.active).must_equal true
    end
    
    it "makes active false if it is true" do
      # arrange
      driver = Driver.create(name: "Micky", vin: "777", active: true)
      driver_id = driver.id
      
      # act
      patch toggle_active_path(driver_id)
      
      updated_driver = Driver.find_by(id: driver_id)
      
      # assert
      expect(updated_driver.active).must_equal false
    end
  end
  
end
