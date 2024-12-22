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

#### Semantic Search
```
GET http://localhost:3000/deliveries/semantic_search
```
- Method: GET
- Authentication: None (development environment)
- Query Parameters:
  - `query` (required): The search query text to find similar deliveries

Example Response:
```json
{
  "query": "string",
  "results": [
    {
      "id": "integer",
      "pickup_address": "string",
      "delivery_address": "string",
      "weight": "decimal",
      "distance": "decimal",
      "cost": "decimal",
      "scheduled_time": "datetime",
      "similarity_score": "float"
    }
  ]
}
```

Example Usage:
```bash
curl "http://localhost:3000/deliveries/semantic_search?query=deliveries in downtown area"
```

Response Details:
- Results are limited to the top 10 most similar deliveries
- Only deliveries with a similarity score < 0.22 are included (lower scores indicate higher similarity)
- Results are sorted by similarity score in ascending order

Error Responses:

1. Missing Query Parameter
```json
{
  "error": "Query parameter is required"
}
```
Status Code: 422

2. OpenAI API Error
```json
{
  "error": "OpenAI API error: [error message]"
}
```
Status Code: 422

3. General Error
```json
{
  "error": "[error message]"
}
```
Status Code: 422

Implementation Notes:
- Uses OpenAI's text-embedding-ada-002 model to generate embeddings
- Employs cosine distance for similarity measurement
- Requires the OPENAI_API_KEY environment variable to be set

Testing Tips:
1. Test with various query types:
   - Location-based queries (e.g., "deliveries in downtown area")
   - Time-based queries (e.g., "urgent deliveries")
   - Weight-based queries (e.g., "heavy packages")

2. Verify error handling:
   - Try empty query parameter
   - Test with invalid API key
   - Check response with no matching results

3. Performance considerations:
   - Response time may vary based on OpenAI API latency
   - Large result sets are automatically limited to 10 items

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