require 'net/http'
require 'uri'

uri = URI.parse("https://portal.ncbar.gov/Verification/search.aspx")
request = Net::HTTP::Get.new(uri)
request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
request["Accept-Language"] = "en-US,en;q=0.9"
request["Cache-Control"] = "max-age=0"
request["Connection"] = "keep-alive"
request["Cookie"] = "ASP.NET_SessionId=vliir4y4gye325jtbu0jzxuv"
request["Sec-Fetch-Dest"] = "document"
request["Sec-Fetch-Mode"] = "navigate"
request["Sec-Fetch-Site"] = "none"
request["Sec-Fetch-User"] = "?1"
request["Upgrade-Insecure-Requests"] = "1"
request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36"
request["Sec-Ch-Ua"] = "\"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\""
request["Sec-Ch-Ua-Mobile"] = "?0"
request["Sec-Ch-Ua-Platform"] = "\"Linux\""

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# response.code
puts response.body