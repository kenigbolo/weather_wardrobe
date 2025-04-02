class AiRecommendationService
  include HTTParty
  base_uri 'https://api-inference.huggingface.co/models'

  def initialize(prompt:, model: 'google/flan-t5-large')
    @prompt = prompt
    @model = model
    @headers = {
      "Authorization" => "Bearer #{ENV['HUGGINGFACE_API_TOKEN']}",
      "Content-Type" => "application/json"
    }
  end

  def recommend
    response = self.class.post(
      "/#{@model}",
      headers: @headers,
      body: { inputs: @prompt }.to_json
    )

    if response.code == 200
      extract_output(response)
    else
      {
        error: "AI model failed to respond",
        status: response.code,
        debug: response.parsed_response
      }
    end
  end

  private

  def extract_output(response)
    body = response.parsed_response

    if body.is_a?(Array) && body.first['generated_text']
      { recommendation: body.first['generated_text'] }
    else
      { error: "Unexpected AI response format", debug: body }
    end
  end
end

