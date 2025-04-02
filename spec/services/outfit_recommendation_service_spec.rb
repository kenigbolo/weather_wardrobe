require 'rails_helper'

RSpec.describe OutfitRecommendationService do
  describe '#recommend' do
    it 'recommends warm clothes for cold weather' do
      weather_data = {
        'main' => { 'temp' => 2 },
        'weather' => [{ 'main' => 'Snow' }]
      }

      service = OutfitRecommendationService.new(weather_data)
      result = service.recommend

      expect(result).to include("thermal jacket", "snow boots", "thick coat")
    end

    it 'recommends light clothes and sunglasses for hot, clear weather' do
      weather_data = {
        'main' => { 'temp' => 30 },
        'weather' => [{ 'main' => 'Clear' }]
      }

      service = OutfitRecommendationService.new(weather_data)
      result = service.recommend

      expect(result).to include("shorts", "sunglasses")
      expect(result).not_to include("jacket")
    end

    it 'adds an umbrella when raining' do
      weather_data = {
        'main' => { 'temp' => 18 },
        'weather' => [{ 'main' => 'Rain' }]
      }

      service = OutfitRecommendationService.new(weather_data)
      result = service.recommend

      expect(result).to include("umbrella", "waterproof jacket")
    end
  end
end
