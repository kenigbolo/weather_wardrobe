class WeatherController < ApplicationController
  # GET /weather?location=CityName
  def index
    # Fallback to "Dublin" if no location is provided in query params
    location = params[:location] || 'Dublin'

    # Create a new instance of the weather service with the given location
    weather = WeatherService.new(location).fetch_current_weather

    # Check if the API call was successful
    if weather.code == 200
      # Return the weather data as JSON (parsed_response converts it from raw HTTP to JSON)
      render json: weather.parsed_response
    else
      # Return an error message if the location is invalid or not found
      render json: { error: "Could not find weather for '#{location}'" }, status: :not_found
    end
  end
end
