class DeliveriesController < ApplicationController
  def index
    @deliveries = Delivery.order(created_at: :desc).page(params[:page]).per(10)
    
    if params[:pickup_address].present?
      @deliveries = @deliveries.where("pickup_address ILIKE ?", "%#{params[:pickup_address]}%")
    end
    
    if params[:driver_name].present?
      @deliveries = @deliveries.where("driver_name ILIKE ?", "%#{params[:driver_name]}%")
    end
  end

  def new
    @delivery = Delivery.new
  end

  def create
    @delivery = Delivery.new(delivery_params)
    
    if @delivery.save
      redirect_to deliveries_path, notice: 'Delivery was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def total_cost
    begin
      total = Delivery.sum(:cost)
      render json: { 
        total_cost: total.round(2),
        success: true
      }
    rescue => e
      Rails.logger.error("Error calculating total cost: #{e.message}")
      render json: { 
        error: 'Failed to calculate total cost',
        success: false
      }, status: :internal_server_error
    end
  end

  def optimized_routes
    routes = Delivery.all
      .group_by(&:pickup_address)
      .transform_values do |deliveries|
        deliveries.sort_by(&:distance)
      end
    
    render json: { optimized_routes: routes }
  end

  def semantic_search
    return render json: { error: 'Query parameter is required' }, status: :unprocessable_entity if params[:query].blank?

    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    
    begin
      # Generate embedding for the search query
      response = client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: params[:query]
        }
      )
      
      query_embedding = response.dig("data", 0, "embedding")
      return render json: { error: 'Failed to generate embedding for query' }, status: :unprocessable_entity unless query_embedding

      Rails.logger.info "Query embedding generated successfully: #{query_embedding.size} dimensions"
      
      # Find similar deliveries using the neighbor gem's methods
      similar_deliveries = Delivery.nearest_neighbors(
        :embedding, 
        query_embedding, 
        distance: 'cosine'
      ).select { |d| d.neighbor_distance < 0.22 } # Only include results with good similarity
        .first(10) # Limit to top 10 results
      
      Rails.logger.info "Found #{similar_deliveries.size} similar deliveries"
      
      render json: {
        query: params[:query],
        results: similar_deliveries.map do |delivery|
          {
            id: delivery.id,
            pickup_address: delivery.pickup_address,
            delivery_address: delivery.delivery_address,
            weight: delivery.weight,
            distance: delivery.distance,
            cost: delivery.cost,
            scheduled_time: delivery.scheduled_time,
            similarity_score: delivery.neighbor_distance
          }
        end
      }
    rescue OpenAI::Error => e
      Rails.logger.error "OpenAI API error: #{e.message}"
      render json: { error: "OpenAI API error: #{e.message}" }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Error in semantic search: #{e.message}\n#{e.backtrace.join("\n")}"
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def delivery_params
    params.require(:delivery).permit(
      :pickup_address,
      :delivery_address,
      :weight,
      :distance,
      :scheduled_time,
      :driver_name
    )
  end
end