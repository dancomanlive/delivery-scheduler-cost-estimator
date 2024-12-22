# Delivery Scheduler and Cost Estimator

A Ruby on Rails application for managing deliveries, scheduling, and cost estimation. This application allows users to create deliveries, view scheduled deliveries in a paginated table, filter deliveries by various criteria, and calculate total costs.

## Features

- Create and schedule new deliveries
- View all deliveries in a paginated table
- Filter deliveries by pickup address and driver name
- Automatic cost calculation based on weight and distance
- Mobile-friendly design using Tailwind CSS
- Basic route optimization for deliveries with the same pickup address

## Requirements

- Ruby 3.3.6
- Rails 8.0.0
- PostgreSQL 17
- Node.js and Yarn (for asset compilation)

## Setup

1. Clone the repository:
```bash
git clone [repository-url]
cd [repository-name]
```

2. Install dependencies:
```bash
bundle install
```

3. Database setup:
```bash
rails db:create
rails db:migrate
```

4. Load sample data (optional):
```bash
rails db:seed
```

5. Start the server:
```bash
rails server
```

The application will be available at `http://localhost:3000`

## Usage

### Creating a New Delivery

1. Click "New Delivery" button on the main page
2. Fill in the required fields:
   - Pickup Address
   - Delivery Address
   - Weight (kg)
   - Distance (km)
   - Scheduled Time
   - Driver Name (optional)
3. Submit the form

### Viewing and Filtering Deliveries

- All deliveries are displayed in a paginated table (10 per page)
- Use the filter fields at the top to search by:
  - Pickup Address
  - Driver Name
- The total cost of all deliveries is displayed below the table

## Cost Calculation

Delivery costs are automatically calculated using the following formula:
- Base rate: $2 per kilometer
- Weight rate: $1.50 per kilogram
- Total cost = (distance × base rate) + (weight × weight rate)

## Testing

Run the test suite:
```bash
rails test
```

This will run:
- Model tests for validation and cost calculation
- Controller tests for all endpoints
- Integration tests for main features

## API Endpoints

### List Deliveries
```
GET /deliveries
```

### Create Delivery
```
POST /deliveries
```

### Get Total Cost
```
GET /deliveries/total_cost
```

### Get Optimized Routes
```
GET /deliveries/optimized_routes
```

## Project Structure

Key files and directories:

```
app/
  ├── controllers/
  │   └── deliveries_controller.rb
  ├── models/
  │   └── delivery.rb
  └── views/
      └── deliveries/
          ├── index.html.erb
          └── new.html.erb
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Future Improvements

- [ ] Add user authentication
- [ ] Implement real-time delivery tracking
- [ ] Add email notifications for delivery updates
- [ ] Integrate with mapping services for distance calculation
- [ ] Add more sophisticated route optimization algorithms
- [ ] Implement the LLM-based natural language query feature

## License

This project is licensed under the MIT License - see the LICENSE.md file for details