class GeminiService

    def self.call
        require "net/http"
        require "uri"
        require "json"

        api_key = ENV["GEMINI_API_KEY"]

        uri = URI("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=#{api_key}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri)
        request["Content-Type"] = "application/json"

        request.body = {
            contents: [
            {
                parts: [
                    { text: "こんにちは、元気ですか？" }
                ]
            }
            ]
        }.to_json

        response = http.request(request)
        json = JSON.parse(response.body)

        json.dig("candidates", 0, "content", "parts", 0, "text")
    end
end