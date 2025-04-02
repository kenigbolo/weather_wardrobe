require 'rails_helper'

RSpec.describe WeatherService do
  let(:location) { 'London' }
  let(:api_key) { 'fake_api_key' }

  before do
    # Stub ENV variable
    # I use allow(ENV).to receive(:[]) to mock ENV['OPENWEATHER_API_KEY'] for test safety
    allow(ENV).to receive(:[]).with('OPENWEATHER_API_KEY').and_return(api_key)

    # Define a sample response that mimics OpenWeather API
    @sample_response = {
      coord: { lon: -0.13, lat: 51.51 },
      weather: [{ main: "Rain", description: "light rain" }],
      main: { temp: 10.5, feels_like: 8.9 }
    }.to_json
  end

  describe '#fetch_current_weather' do
    context 'when location is valid' do
      it 'returns parsed weather data with status 200' do
        # Stub the GET request to return our sample response
        stub_request(:get, /api.openweathermap.org/)
          .with(query: hash_including(q: location, appid: api_key))
          .to_return(status: 200, body: @sample_response, headers: { 'Content-Type' => 'application/json' })

        service = WeatherService.new(location)
        response = service.fetch_current_weather

        expect(response.code).to eq(200)
        json = response.parsed_response
        expect(json['main']['temp']).to eq(10.5)
        expect(json['weather'].first['main']).to eq('Rain')
      end
    end

    context 'when location is invalid' do
      it 'returns a 404 error response' do
        stub_request(:get, /api.openweathermap.org/)
          .with(query: hash_including(q: 'FakeCity'))
          .to_return(
            status: 404,
            body: { message: 'city not found' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
    
        service = WeatherService.new('FakeCity')
        response = service.fetch_current_weather
    
        expect(response.code).to eq(404)
        expect(response.parsed_response['message']).to eq('city not found')
      end
    end    
  end
end
