## 🧠 Design Decisions & Trade-offs

---

This section highlights the key architectural choices and practical trade-offs made while developing the Weather-Based Clothing Advisor API.

---

### 1. 🧾 **API-Only Rails App**
- ✅ **Decision:** Build the backend as a lightweight, API-only Ruby on Rails app.
- 📌 **Why:** Rails gives us powerful tooling, easy routing, clean structure, and built-in test framework — while staying lean in API-only mode.
- ⚠️ **Trade-off:** No frontend views or page rendering — requires separate React frontend (coming soon).

---

### 2. 🌦 **Use of OpenWeatherMap API**
- ✅ **Decision:** Pull live weather data using the OpenWeatherMap v2.5 REST API.
- 📌 **Why:** It’s reliable, free-tier friendly, and returns essential weather info like condition, temperature, wind speed, and descriptions.
- ⚠️ **Trade-off:** Doesn’t directly provide "season", so we decided not to infer it from the date/latitude to keep logic simple.

---

### 3. 🧠 **AI-Powered Recommendations via Hugging Face**
- ✅ **Decision:** Use Hugging Face’s hosted `google/flan-t5-large` model to generate outfit suggestions using natural language.
- 📌 **Why:** Provides expressive, human-like recommendations with minimal hand-coded logic. Faster and more scalable than rule-based engines.
- ⚠️ **Trade-off:** Output is non-deterministic and depends heavily on prompt quality. Free-tier inference can be slower for larger models.

---

### 4. ✍️ **Prompt Engineering for Better Results**
- ✅ **Decision:** Enrich the AI prompt with temperature, wind speed, "feels like" data, and condition to generate high-quality, detailed outfit recommendations.
- 📌 **Why:** A simple prompt like "Suggest an outfit for rain" returned responses like `"a jacket"`. Enriched prompts significantly improved results.
- ⚠️ **Trade-off:** Prompt construction requires carefully combining multiple data points and formatting with fail-safes (e.g., if wind speed is missing).

---

### 5. 🧪 **Robust Test Coverage with Stubbing**
- ✅ **Decision:** Use RSpec and WebMock to fully stub OpenWeatherMap and Hugging Face API responses in test mode.
- 📌 **Why:** Ensures fast, stable test runs without relying on live API access.
- ⚠️ **Trade-off:** Real integrations aren’t tested — needs occasional manual validation in staging/dev.

---

### 6. 💬 **Plain Text AI Output (for now)**
- ✅ **Decision:** Leave the AI output as natural, unstructured text.
- 📌 **Why:** Simple to integrate and display. Prompts guide the model to include bullet lists and style notes.
- ⚠️ **Trade-off:** Slightly harder to parse on frontend — we plan to extract structure in the React app phase.

---

In addition, throughout development, a few key decisions were made to balance simplicity, clarity, and functionality:

### 1. **Prompt-Based AI over Rule-Based Logic**
- ✅ **Decision:** Use Hugging Face + natural language prompts to generate outfit suggestions instead of maintaining a large decision tree or rule engine.
- 📌 **Why:** Faster to iterate and allows more personalized, expressive recommendations with minimal hardcoding.
- ⚠️ **Trade-off:** Less deterministic — output quality depends on model strength and prompt quality.

---

### 2. **Model Selection: `flan-t5-large`**
- ✅ **Decision:** Switch from the default `flan-t5-base` to `flan-t5-large` for improved prompt comprehension and richer output.
- 📌 **Why:** `flan-t5-base` returned overly simple results like "a jacket", while `large` could understand multi-part requests.
- ⚠️ **Trade-off:** Slightly slower response time, higher inference cost (though still free-tier friendly on Hugging Face).

---

### 3. **Prompt Composition in Controller**
- ✅ **Decision:** Dynamically build a natural language prompt using weather data (temperature, feels like, wind, condition).
- 📌 **Why:** Improves the context of the recommendation and allows the AI to reason with environmental data.
- ⚠️ **Trade-off:** Requires careful formatting and fallback logic (e.g., missing wind speed) to avoid breaking the prompt.

---

### 4. **Mocking External APIs in Tests**
- ✅ **Decision:** Use WebMock and RSpec to stub both OpenWeatherMap and Hugging Face API calls.
- 📌 **Why:** Prevents flaky tests due to network/API issues and speeds up test execution.
- ⚠️ **Trade-off:** Doesn't test the live API integration — needs occasional real-world testing for validation.

---

## 🧩 Challenge Solved

**Problem:**  
Initial outfit suggestions from the AI were too simplistic and ignored key weather context (e.g., `"a jacket"` for any condition).

**Solution:**  
By enriching the prompt with detailed weather data (temperature, wind, description), using a more powerful Hugging Face model (`flan-t5-large`), and formatting the prompt to explicitly ask for bullet lists and style notes, we consistently achieved expressive, practical, and personalized outfit recommendations.

---

### ✅ Result: A flexible, testable Rails API that integrates real-time weather with natural language fashion advice — ready to be consumed by a frontend application.

---