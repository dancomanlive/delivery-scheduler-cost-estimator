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