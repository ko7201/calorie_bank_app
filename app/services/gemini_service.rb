class GeminiService
  def self.call(calorie_record)
    require "net/http"
    require "uri"
    require "json"
    require "base64"

    api_key = ENV["GEMINI_API_KEY"]
    uri = URI("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=#{api_key}")

    image_data = Base64.strict_encode64(calorie_record.image.read)

    prompt = <<~PROMPT
      あなたは食事画像からカロリーを推定するアシスタントです。
      提供された画像をもとに、料理名・丼もの判定・食品ごとのカロリーを推定してください。

      ## 出力形式
      必ずJSONのみで返してください。説明文やMarkdownは不要です。
      {
        "dish": "料理名",
        "is_donburi": true または false,
        "confidence": 数値（0〜100）,
        "foods": [
          {
            "name": "食品名",
            "grams": 数値,
            "calories": 数値
          }
        ],
        "total_calories": 数値
      }

      ## 丼もの判定
      - 親子丼、牛丼、カツ丼、海鮮丼、天丼など、ご飯の上に具材が乗って一体の料理になっているものは is_donburi を true にしてください
      - 定食、弁当、おかず単品、副菜、汁物などは is_donburi を false にしてください

      ## 白米・ご飯の扱い
      - is_donburi が true の場合：
        - 白米・ご飯も foods に含めてください
        - 丼もの全体のカロリーとして推定してください
      - is_donburi が false の場合：
        - 画像に白米・ご飯が写っていても foods に含めないでください
        - 白米・ご飯のカロリーはアプリ側で別途計算するため、推定対象外にしてください

      ## 推定方針
      - 食事を構成する食品をできるだけ分解してください
      - 各食品について分量（g）とカロリーを推定してください
      - 油、衣、ソース、タレ、調味料も考慮してください
      - 見えにくい調味料も、料理として自然な範囲で考慮してください

      ## 分量の目安
      - 丼もののご飯：250〜300g
      - 肉・魚：80〜150g
      - 卵：1個50〜60g
      - 豆腐：75〜100g
      - 副菜：20〜50g
      - サラダ：50〜80g
      - 漬物：10〜20g
      - 汁物：150〜200ml

      ## 確信度の基準
      - 90〜100：明確に識別でき、分量も判定しやすい
      - 70〜89：識別できるが、分量がやや判定しにくい
      - 50〜69：識別または分量推定に不確実性がある
      - 30〜49：推定が困難

      ## カロリー推定の考え方
      - 極端に少ないカロリーにならないようにしてください
      - 一般的な食事として自然な範囲の値にしてください
      - 不確実な場合は確信度を下げて、一般的な平均値を使ってください

      ## 最終チェック
      - total_calories は foods の calories の合計と必ず一致させてください
      - 合計が不自然に低い場合は、食品の分量や油・調味料の見積もりを見直してください

      ## 出力ルール（重要）
      - 数値は必ず数値型で出力してください（文字列は禁止）
      - nullは使用しないでください
      - すべてのキーを必ず出力してください
      - JSON以外の文章・説明・コードブロック（```）は一切出力しないでください
    PROMPT

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"

    request.body = {
      contents: [
        {
          parts: [
            { text: prompt },
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

      unless response.code == "200"
        Rails.logger.error("Gemini API error: #{response.body}")
        return nil
      end

      json = JSON.parse(response.body)
      text = json.dig("candidates", 0, "content", "parts", 0, "text")

      return nil if text.blank?

      # Geminiがコードブロックで囲んで返すことがあるので除去
      cleaned = text.gsub(/```json\s*/i, "").gsub(/```\s*/, "").strip

      parsed = JSON.parse(cleaned)

      # === 整合性チェック（AI+αの核心部分） ===
      # Geminiの返すtotal_caloriesを信用せず、foods配列から再計算する
      foods = parsed["foods"] || []
      recalculated_total = foods.sum { |f| f["calories"].to_i }
      parsed["total_calories"] = recalculated_total

      # calorie_recordに結果を反映
      calorie_record.ai_dish_name = parsed["dish"]
      calorie_record.ai_confidence = parsed["confidence"].to_i
      calorie_record.ai_foods = foods
      calorie_record.is_donburi = parsed["is_donburi"] == true
      calorie_record.base_calorie = recalculated_total

      recalculated_total

    rescue JSON::ParserError => e
      Rails.logger.error("Gemini JSON parse error: #{e.message}")
      Rails.logger.error("Raw response: #{text}")
      nil
    rescue => e
      Rails.logger.error("Gemini API request failed: #{e.message}")
      nil
    end
  end
end
