class OutfitRecommendationService
  def initialize(weather_data)
    @temperature = weather_data.dig('main', 'temp')
    @condition = weather_data.dig('weather', 0, 'main')&.downcase
  end

  def recommend
    outfit = []

    # Base temperature ranges
    if @temperature <= 5
      outfit += ["thermal jacket", "scarf", "gloves"]
    elsif @temperature <= 15
      outfit += ["jacket", "long sleeves"]
    elsif @temperature <= 25
      outfit += ["t-shirt", "light jacket"]
    else
      outfit += ["tank top", "shorts"]
    end

    # Adjust for weather conditions
    case @condition
    when 'rain'
      outfit << "umbrella"
      outfit << "waterproof jacket"
    when 'snow'
      outfit << "snow boots"
      outfit << "thick coat"
    when 'clear'
      outfit << "sunglasses"
    when 'wind'
      outfit << "windbreaker"
    end

    outfit.uniq
  end
end
