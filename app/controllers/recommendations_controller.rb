class RecommendationsController < ApplicationController
  def index
    location = params[:location] || 'Dublin'

    # Fetch weather data from OpenWeatherMap
    weather_response = WeatherService.new(location).fetch_current_weather

    unless weather_response.code == 200
      return render json: {
        error: "Could not get weather for '#{location}'",
        status: weather_response.code
      }, status: :not_found
    end

    weather_data = weather_response.parsed_response
    weather_condition = weather_data.dig('weather', 0, 'main') || 'Unknown'

    temp = (weather_data.dig('main', 'temp')).round
    feels_like = (weather_data.dig('main', 'feels_like')).round
    description = weather_data.dig('weather', 0, 'description')
    wind = (weather_data.dig('wind', 'speed') * 3.6).round
    location = params[:location] || 'Dublin'
    conjunction = feels_like == temp ? "and" : "but"



    # Build the natural language prompt
    prompt = "It's currently #{temp}°C #{conjunction} feels like #{feels_like}°C, with #{description} and winds of #{wind} km/h. It's evening in #{location}.
    Suggest a complete outfit that includes outerwear, footwear, and accessories."

    # Ask Hugging Face
    ai_result = AiRecommendationService.new(prompt: prompt).recommend

    if ai_result[:error]
      render json: {
        prompt_used: prompt,
        error: ai_result[:error],
        debug: ai_result[:debug]
      }, status: :bad_gateway
    else
      render json: {
        prompt_used: prompt,
        outfit_ai: ai_result[:recommendation]
      }
    end
  end
end

