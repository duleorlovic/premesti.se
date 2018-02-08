class Admin::LocationsController < AdminController
  before_action :set_city, only: %i[index new create]
  before_action :set_location, only: %i[show edit update destroy]

  def index; end

  def new
    @location = @city.locations.new
    render layout: false
  end

  def create
    @location = Location.new location_params.merge(
      city: @city
    )
    @location.save
  end

  def show; end

  def edit
    render layout: false
  end

  def update
    @location.update location_params
  end

  def destroy
    city = @location.city
    @location.destroy
    redirect_to admin_locations_path city: city.name
  end

  private

  def set_city
    redirect_to admin_dashboard_path and return unless params[:city_id].present?
    @city = City.find params[:city_id]
  end

  def set_location
    @location = Location.find params[:id]
  end

  def location_params
    params.require(:location).permit(
      :name, :address, :latitude, :longitude
    )
  end
end
