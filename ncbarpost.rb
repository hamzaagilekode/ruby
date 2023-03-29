require 'net/http'
require 'uri'
require "nokogiri"
require "open-uri"
require "httparty"
url = "https://portal.ncbar.gov/Verification/search.aspx"
uri = URI.parse(url)
res = HTTParty.get(url)
request = Net::HTTP::Post.new(uri)
# creating header

headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Cookie': 'cookies = response.headers['set-cookie']'
}
## addition up
request.content_type = "application/x-www-form-urlencoded"
request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
request["Accept-Language"] = "en-US,en;q=0.9"
request["Cache-Control"] = "max-age=0"
request["Connection"] = "keep-alive"
request["Cookie"] = "ASP.NET_SessionId=n0hcb05fj3kbib5rhhjlo2eb"
request["Origin"] = "https://portal.ncbar.gov"
request["Referer"] = "https://portal.ncbar.gov/Verification/search.aspx"
request["Sec-Fetch-Dest"] = "document"
request["Sec-Fetch-Mode"] = "navigate"
request["Sec-Fetch-Site"] = "same-origin"
request["Sec-Fetch-User"] = "?1"
request["Upgrade-Insecure-Requests"] = "1"
request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36"
request["Sec-Ch-Ua"] = "\"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\""
request["Sec-Ch-Ua-Mobile"] = "?0"
request["Sec-Ch-Ua-Platform"] = "\"Linux\""
document = Nokogiri::HTML(res.body)
viewstate = document.css("#__VIEWSTATE")[0]["value"]
viewstategenerator = document.css("#__VIEWSTATEGENERATOR")[0]["value"]
eventvalidation = document.css("#__EVENTVALIDATION")[0]["value"]
request.set_form_data(
  "__EVENTARGUMENT" => "",
  "__EVENTTARGET" => "",
  "__EVENTVALIDATION" => eventvalidation
  "__VIEWSTATE" => viewstate,
  "__VIEWSTATEGENERATOR" => viewstategenerator,
  "ctl00$Content$btnSubmit" => "Search",
  "ctl00$Content$ddJudicialDistrict" => "",
  "ctl00$Content$ddLicStatus" => "",
  "ctl00$Content$ddLicType" => "",
  "ctl00$Content$ddSpecialization" => "Criminal Law State",
  "ctl00$Content$ddState" => "",
  "ctl00$Content$txtCity" => "",
  "ctl00$Content$txtFirst" => "",
  "ctl00$Content$txtLast" => "",
  "ctl00$Content$txtLicNum" => "",
  "ctl00$Content$txtMiddle" => "",
)

req_options = {
  use_ssl: uri.scheme == "https",
}

# response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
#   http.request(request)
# end
response = Net::HTTP.post(uri, URI.encode_www_form(body), headers)

name = doc.css('#ctl00$Content$ddSpecialization').text

# puts response.body
puts eventvalidation

#making a post request
response = HTTParty.post(
    base_url,
    headers: {
      'Cookie' => cookies,
      'Referer' => base_url,
      'Content-Type' => 'application/x-www-form-urlencoded'
    },
    body: search_params
)
  
  # Parse the response HTML to extract the search results
document = Nokogiri::HTML(response.body)
search_results = document.css('#ContentPlaceHolder1_divResults').text.strip
puts search_results