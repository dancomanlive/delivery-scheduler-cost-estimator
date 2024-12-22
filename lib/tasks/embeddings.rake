namespace :embeddings do
  desc "Generate embeddings for all deliveries"
  task generate: :environment do
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    
    Delivery.find_each do |delivery|
      # Create a text representation of the delivery
      text = "Delivery from #{delivery.pickup_address} to #{delivery.delivery_address}. " \
             "Weight: #{delivery.weight}kg. Distance: #{delivery.distance}km. " \
             "Cost: $#{delivery.cost}. Driver: #{delivery.driver_name}. " \
             "Scheduled for: #{delivery.scheduled_time}"
      
      # Generate embedding
      response = client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: text
        }
      )
      
      embedding = response.dig("data", 0, "embedding")
      
      # Update the delivery with the embedding
      delivery.update!(embedding: embedding)
      
      puts "Generated embedding for delivery ##{delivery.id}"
    rescue StandardError => e
      puts "Error generating embedding for delivery ##{delivery.id}: #{e.message}"
    end
  end
end