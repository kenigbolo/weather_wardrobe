class RecommendationsController < ApplicationController
  def index
    location = params[:location] || 'Dublin'
    weather_response = WeatherService.new(location).fetch_current_weather

    # If the weather API call fails
    unless weather_response.code == 200
      return render json: { error: "Could not get weather for '#{location}'" }, status: :not_found
    end

    # Parse the weather JSON
    weather_data = weather_response.parsed_response

    # Get outfit suggestions based on the weather
    outfit = OutfitRecommendationService.new(weather_data).recommend

    # Return both weather and outfit suggestion
    render json: {
      location: location,
      weather: {
        temp: weather_data.dig('main', 'temp'),
        condition: weather_data.dig('weather', 0, 'main'),
      },
      outfit: outfit
    }
  end
end

