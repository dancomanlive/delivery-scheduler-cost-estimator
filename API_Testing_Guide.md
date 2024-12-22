## API Endpoints and Postman Testing

### Setting up Postman

1. Download and install [Postman](https://www.postman.com/downloads/)
2. Create a new collection called "Delivery Scheduler"
3. Make sure your Rails server is running (`rails server`)

### Testing Endpoints

#### List Deliveries
```
GET http://localhost:3000/deliveries
```
- Method: GET
- Headers: None required
- Query Parameters (optional):
  - `page`: Page number (e.g., `?page=2`)
  - `pickup_address`: Filter by pickup address (e.g., `?pickup_address=Amsterdam`)
  - `driver_name`: Filter by driver name (e.g., `?driver_name=John`)

Example Response:
```json
{
  "deliveries": [
    {
      "id": 1,
      "pickup_address": "123 Start Street, Amsterdam",
      "delivery_address": "987 End Road, Groningen",
      "weight": 25.5,
      "distance": 45.2,
      "cost": 128.25,
      "scheduled_time": "2024-12-25T14:30:00Z",
      "driver_name": "John Smith"
    },
    // ... more deliveries
  ]
}
```

#### Create Delivery
```
POST http://localhost:3000/deliveries
```
- Method: POST
- Headers: 
  - Content-Type: application/json
  - X-CSRF-Token: [Get this from your browser or disable CSRF in development]
- Body:
```json
{
  "delivery": {
    "pickup_address": "123 Start Street",
    "delivery_address": "456 End Road",
    "weight": 15.5,
    "distance": 25.0,
    "scheduled_time": "2024-12-25T14:30:00Z",
    "driver_name": "John Smith"
  }
}
```

Example Response:
```json
{
  "id": 1,
  "message": "Delivery was successfully created",
  "delivery": {
    // delivery details
  }
}
```

#### Get Total Cost
```
GET http://localhost:3000/deliveries/total_cost
```
- Method: GET
- Headers: None required

Example Response:
```json
{
  "total_cost": 1234.56
}
```

#### Get Optimized Routes
```
GET http://localhost:3000/deliveries/total_cost
```
- Method: GET
- Headers: None required

Example Response:
```json
{
  "optimized_routes": {
    "123 Start Street, Amsterdam": [
      {
        "id": 1,
        "delivery_address": "987 End Road",
        "distance": 25.0,
        // ... other delivery details
      },
      // ... more deliveries from same pickup
    ],
    // ... more pickup addresses
  }
}
```

### Handling CSRF Protection

For POST requests in development, you have two options:

1. **Disable CSRF for API requests** (Development only!)
   
   In `app/controllers/deliveries_controller.rb`, add:
   ```ruby
   skip_before_action :verify_authenticity_token, if: -> { Rails.env.development? }
   ```

2. **Include CSRF Token** (Recommended for production)
   
   Get the token from your browser:
   1. Open your browser's developer tools
   2. Visit any page in your Rails app
   3. In the console, type:
      ```javascript
      document.querySelector('meta[name="csrf-token"]').content
      ```
   4. Copy the token and add it to your Postman request headers:
      ```
      X-CSRF-Token: [your-token-here]
      ```

### Common Issues

1. **422 Unprocessable Entity**
   - Check if all required fields are included in your request
   - Verify the data types (numbers for weight/distance)
   - Ensure datetime format is correct

2. **500 Internal Server Error**
   - Check your Rails server logs for details
   - Verify database connection
   - Ensure all required services are running

3. **CSRF Token Issues**
   - Follow the CSRF handling instructions above
   - For testing, you can temporarily disable CSRF protection