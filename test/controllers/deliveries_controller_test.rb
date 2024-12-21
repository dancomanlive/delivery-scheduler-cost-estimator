require "test_helper"

class DeliveriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get deliveries_url
    assert_response :success
  end

  test "should get new" do
    get new_delivery_url
    assert_response :success
  end

  test "should create delivery" do
    assert_difference("Delivery.count") do
      post deliveries_url, params: {
        delivery: {
          pickup_address: "123 Start St",
          delivery_address: "456 End Ave",
          weight: 10.5,
          distance: 15.2,
          scheduled_time: Time.current,
          driver_name: "John Doe"
        }
      }
    end

    assert_redirected_to deliveries_url
  end

  test "should get total cost" do
    get total_cost_deliveries_url
    assert_response :success
    assert_equal "application/json", @response.media_type
    
    json_response = JSON.parse(@response.body)
    assert json_response.key?("total_cost")
  end

  test "should get optimized routes" do
    get optimized_routes_deliveries_url
    assert_response :success
    assert_equal "application/json", @response.media_type
    
    json_response = JSON.parse(@response.body)
    assert json_response.key?("optimized_routes")
  end
end