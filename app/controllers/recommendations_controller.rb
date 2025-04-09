class RecommendationsController < ApplicationController
  def index
    location = params[:location] || 'Dublin'

    # Fetch weather data from OpenWeatherMap
    weather_response = WeatherService.new(location).fetch_current_weather
    return render_weather_error(location, weather_response.code) unless weather_response.code == 200

    weather_data = weather_response.parsed_response
    time_of_day = extract_local_time_info(weather_data)
    weather_info = extract_weather_info(weather_data)

    weather_condition = weather_info[:weather_condition]
    temp              = weather_info[:temp]
    feels_like        = weather_info[:feels_like]
    description       = weather_info[:description]
    wind_kmh          = weather_info[:wind_kmh]
    
    if weather_data.dig('wind', 'speed').nil?
      Rails.logger.warn("[Weather] Missing wind speed in API response for #{location}")
    end

    # Choose conjunction: "and" or "but"
    conjunction = temp == feels_like ? "and" : "but"

    # Build the prompt for Hugging Face
    prompt = <<~PROMPT.strip
      It's currently #{temp}°C #{conjunction} feels like #{feels_like}°C, with #{description} and winds of #{wind_kmh} km/h.
      It's #{time_of_day} in #{location}. Suggest a complete outfit that includes outerwear, footwear, and accessories.
    PROMPT


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
        location: location,
        weather_condition: weather_condition,
        prompt_used: prompt,
        outfit_ai: ai_result[:recommendation]
      }
    end
  end
  private

  def render_weather_error(location, status)
    render json: {
      error: "Could not get weather for '#{location}'",
      status: status
    }, status: :not_found
  end

  def extract_local_time_info(weather_data)
    utc_timestamp = weather_data['dt']
    timezone_offset = weather_data['timezone'] || 0
  
    # Calculate local time
    local_timestamp = Time.at(utc_timestamp + timezone_offset)
  
    # Format as human-readable time
    local_time_string = local_timestamp.strftime('%-I:%M %p') # e.g., 7:45 PM
  
    # Determine time of day label
    hour = local_timestamp.hour
    return time_period =
      case hour
      when 5..11 then 'morning'
      when 12..16 then 'afternoon'
      when 17..20 then 'evening'
      else 'night'
      end
  end  

  def extract_weather_info(weather_data)
    {
      weather_condition: weather_data.dig('weather', 0, 'main') || 'Unknown',
      temp: weather_data.dig('main', 'temp')&.round,
      feels_like: weather_data.dig('main', 'feels_like')&.round,
      description: weather_data.dig('weather', 0, 'description'),
      wind_kmh: ((weather_data.dig('wind', 'speed') || 0) * 3.6).round
    }
  end  
end

