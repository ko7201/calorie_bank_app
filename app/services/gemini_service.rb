class GeminiService
    def self.call(calorie_record)
        require "net/http"
        require "uri"
        require "json"
        require "base64"

        api_key = ENV["GEMINI_API_KEY"]

        uri = URI("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=#{api_key}")

        image_data = Base64.strict_encode64(calorie_record.image.read)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri)
        request["Content-Type"] = "application/json"

        request.body = {
            contents: [
            {
                parts: [
                    { text: "この食事のカロリーを数字だけください" },
                    { inline_data: {
                        mime_type: "image/jpeg",
                        data: image_data
                    } }
                ]
            }
            ]
        }.to_json

        begin
            response = http.request(request)
            puts response.body

            unless response.code == "200"
                Rails.logger.error("Gemini API error: #{response.body}")
                return nil
            end

                json = JSON.parse(response.body)
                json.dig("candidates", 0, "content", "parts", 0, "text")
        rescue => e
            Rails.logger.error("Gemini API request failed: #{e.message}")
            nil
        end
    end
end
