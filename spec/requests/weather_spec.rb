require 'rails_helper'

RSpec.describe "Weather API", type: :request do
  describe "GET /weather" do
    before do
      # Common fake response used for successful weather call
      @fake_weather_response = {
        coord: { lon: -0.13, lat: 51.51 },
        weather: [{ main: "Clouds", description: "broken clouds" }],
        main: { temp: 13.5, feels_like: 12.0 }
      }.to_json
    end

    it "returns weather data for a valid location" do
      # Stub external call to OpenWeather API
      stub_request(:get, /api.openweathermap.org/)
        .to_return(status: 200, body: @fake_weather_response, headers: { 'Content-Type' => 'application/json' })

      get '/weather', params: { location: 'London' }

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json).to have_key("main")
      expect(json["main"]["temp"]).to eq(13.5)
    end

    it "returns error for invalid location" do
      # Simulate a 404 response from the API
      stub_request(:get, /api.openweathermap.org/)
        .to_return(status: 404, body: { message: "city not found" }.to_json)

      get '/weather', params: { location: 'nonexistentcity' }

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json).to have_key("error")
    end

    it "uses default location if none is provided" do
      stub_request(:get, /api.openweathermap.org/)
        .to_return(status: 200, body: @fake_weather_response)

      get '/weather'

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json).to have_key("main")
    end
  end
end
