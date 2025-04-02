class WeatherService
  # Include HTTParty to make HTTP requests easily
  include HTTParty

  # Set the base URI for the OpenWeatherMap v2.5 API
  base_uri 'https://api.openweathermap.org/data/2.5'

  # Initialize the service with a location (e.g., "London")
  def initialize(location)
    @location = location
    @api_key = ENV['OPENWEATHER_API_KEY'] # API key stored in environment variable
  end

  # Fetch current weather for the given location
  def fetch_current_weather
    self.class.get("/weather", query: {
      q: @location,         # City name (e.g., "London")
      appid: @api_key,      # API key
      units: 'metric'       # Return temperature in Celsius
    })
  end
end
