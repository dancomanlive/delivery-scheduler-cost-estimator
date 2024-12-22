# Delivery Scheduler and Cost Estimator

A Ruby on Rails application for managing deliveries, scheduling, and cost estimation. This application allows users to create deliveries, view scheduled deliveries in a paginated table, filter deliveries by various criteria, and calculate total costs.

## Features

As a user, I can schedule a delivery by providing the necessary details to create a new entry.

As a user, I can view a list of all scheduled deliveries in a paginated format, making it easy to navigate through large datasets.

As a user, I can filter deliveries by pickup address or driver name to quickly find specific records.

As a user, I can see the total cost of all scheduled deliveries displayed below the delivery list for quick reference.

As a user, I can view optimized delivery routes, where deliveries are grouped by pickup address and organized to minimize total distance.

As a user, I can input natural language queries, such as asking for the total cost of deliveries to a specific location, and receive accurate results.

As a developer, I can rely on a structured database and tested backend endpoints to ensure reliable and scalable functionality.

## Requirements

- Ruby 3.3.6
- Rails 8.0.0
- PostgreSQL 17

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

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
