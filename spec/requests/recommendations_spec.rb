require 'rails_helper'

RSpec.describe "Recommendations API", type: :request do
  describe "GET /recommendation" do
    let(:location) { "Berlin" }

    before do
      # Stub API key
      allow(ENV).to receive(:[]).with('OPENWEATHER_API_KEY').and_return('fake_api_key')

      # Sample weather API response
      @sample_weather_data = {
        coord: { lon: 13.41, lat: 52.52 },
        weather: [{ main: "Clear", description: "clear sky" }],
        main: { temp: 27.0, feels_like: 26.0 }
      }.to_json
    end

    it "returns weather and outfit for a valid location" do
      stub_request(:get, /api.openweathermap.org/)
        .with(query: hash_including(q: location))
        .to_return(status: 200, body: @sample_weather_data, headers: { 'Content-Type' => 'application/json' })

      get "/recommendation", params: { location: location }

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)

      # Check overall structure
      expect(json).to have_key("location")
      expect(json["location"]).to eq(location)

      expect(json).to have_key("weather")
      expect(json["weather"]).to include("temp", "condition")

      expect(json).to have_key("outfit")
      expect(json["outfit"]).to be_an(Array)
      expect(json["outfit"]).to include("shorts").or include("sunglasses")
    end

    it "returns error for invalid location" do
      stub_request(:get, /api.openweathermap.org/)
        .with(query: hash_including(q: "Fakeville"))
        .to_return(
          status: 404,
          body: { message: 'city not found' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      get "/recommendation", params: { location: "Fakeville" }

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json).to have_key("error")
    end

    it "uses default location when none is provided" do
      stub_request(:get, /api.openweathermap.org/)
        .with(query: hash_including(q: "Dublin"))
        .to_return(status: 200, body: @sample_weather_data, headers: { 'Content-Type' => 'application/json' })

      get "/recommendation"

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json["location"]).to eq("Dublin")
    end
  end
end

