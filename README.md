# README

# 👕 Weather-Based Clothing Advisor API

This is a simple Ruby on Rails API that suggests **weather-appropriate outfit recommendations** based on the **current weather** in any city. It uses data from the **OpenWeatherMap API** and generates natural language outfit suggestions via the **Hugging Face Inference API**.

---

## 🎯 Goal

Help users dress smartly for the weather by combining:
- **Live weather data** (temperature, condition, wind)
- **Natural language AI** for personalized fashion advice

Example prompt:  
> "It's currently 3°C but feels like -1°C, with light rain and winds of 25 km/h. It's evening in Oslo. Suggest a complete outfit including outerwear, footwear, and accessories."

---

## 🚀 Running the App Locally

### ✅ Prerequisites

- Ruby 3.1+
- Rails 7+
- PostgreSQL or SQLite
- Bundler

### 📦 Setup

1. Clone the repo:

```bash
git clone https://github.com/kenigbolo/weather-outfit-api.git
cd weather-outfit-api
```

2. Install dependencies:

```bash
bundle install
```

3. Set up the database:

```bash
rails db:setup
```

4. Create a `.env` file for API keys:

```bash
touch .env
```

Add this to `.env`:

```dotenv
OPENWEATHER_API_KEY=your_openweather_api_key_here
HUGGINGFACE_API_TOKEN=your_huggingface_token_here
```

5. Run the server:

```bash
rails server
```

Visit: [http://localhost:3000/recommendation?location=Berlin](http://localhost:3000/recommendation?location=Berlin)

---

## 🔗 Third-Party APIs Used

### 🌤 OpenWeatherMap API

Provides current weather data for any location.

- 📌 Sign up: https://openweathermap.org/api
- After registration, get your API key from: [https://home.openweathermap.org/api_keys](https://home.openweathermap.org/api_keys)
- Add the key to your `.env` as `OPENWEATHER_API_KEY`

### 🧠 Hugging Face Inference API

Used to generate natural language outfit suggestions.

- 📌 Sign up: https://huggingface.co/join
- Go to your [Settings > Access Tokens](https://huggingface.co/settings/tokens) and generate a read access token.
- Add the token to your `.env` as `HUGGINGFACE_API_TOKEN`

The app currently uses:  
**Model:** `google/flan-t5-large`  
(you can change this in `AiRecommendationService`)

---

## 🧪 Running Tests

```bash
bundle exec rspec
```

Tests include:
- OpenWeather API stubbing
- Hugging Face AI mock responses
- Validation of fallback logic and prompt structure

---

## 💡 Roadmap Ideas

- 🌍 Infer hemisphere-aware seasons from lat/lon
- 🧑‍🎨 Add React frontend for UX-friendly outfit previews
- 🧥 Parse AI output into structured JSON (items + style note)
- 🧪 Add retry and rate-limiting resilience

---

## 🧵 Example API Response

```json
{
  "location": "Berlin",
  "weather_condition": "Rain",
  "prompt_used": "It's currently 6°C but feels like 4°C, with light rain and winds of 25 km/h. It's evening in Berlin. Suggest a complete outfit that includes outerwear, footwear, and accessories.",
  "outfit_ai": "- Waterproof trench coat\n- Wool scarf\n- Black boots\n\nStyle Note: A functional yet stylish choice to keep you warm and dry."
}
```

---

## 📬 Contact

Feel free to open an issue or PR — contributions welcome! Do kindly note that this is a hobby project to test out basic AI recommendation engines. It may or may not be actively maintained

---
```
