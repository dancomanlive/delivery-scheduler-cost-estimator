# Clear existing data
puts "Clearing existing deliveries..."
Delivery.destroy_all

# Create arrays of sample data
pickup_addresses = [
  "123 Start Street, Amsterdam",
  "456 Begin Road, Rotterdam",
  "789 First Avenue, The Hague",
  "321 Origin Lane, Utrecht",
  "654 Launch Street, Eindhoven"
]

delivery_addresses = [
  "987 End Road, Groningen",
  "654 Final Street, Tilburg",
  "321 Last Avenue, Almere",
  "147 Finish Lane, Breda",
  "258 Complete Road, Nijmegen"
]

driver_names = [
  "John Smith",
  "Maria Garcia",
  "David Wilson",
  "Sarah Johnson",
  "Michael Brown"
]

# Generate random deliveries
puts "Creating sample deliveries..."
30.times do |i|
  delivery = Delivery.create!(
    pickup_address: pickup_addresses.sample,
    delivery_address: delivery_addresses.sample,
    weight: rand(1.0..50.0).round(1),
    distance: rand(1.0..100.0).round(1),
    scheduled_time: Time.current + rand(1..30).days + rand(1..24).hours,
    driver_name: driver_names.sample
  )
  puts "Created delivery ##{i + 1} with ID: #{delivery.id}"
end

puts "Seed completed! Created #{Delivery.count} deliveries."