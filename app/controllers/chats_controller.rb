class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    query = params[:query]
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    
    # Generate embedding for the query
    response = client.embeddings(
      parameters: {
        model: "text-embedding-ada-002",
        input: query
      }
    )
    
    query_embedding = response.dig("data", 0, "embedding")
    
    # Perform similarity search
    similar_deliveries = Delivery.nearest_neighbors(:embedding, query_embedding, distance: 'cosine').limit(5)
    
    # Use GPT to interpret the query and generate a response
    chat_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { 
            role: "system", 
            content: "You are a helpful assistant that answers questions about delivery data. Provide concise, accurate responses based on the delivery records provided."
          },
          { 
            role: "user", 
            content: "Based on this query: #{query}, analyze these delivery records: #{similar_deliveries.to_json}"
          }
        ]
      }
    )
    
    render json: { 
      response: chat_response.dig("choices", 0, "message", "content"),
      similar_deliveries: similar_deliveries
    }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end