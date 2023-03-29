require 'net/http'
require 'uri'
require "nokogiri"
require "active_record"
require "mysql2"
require "digest"
ActiveRecord::Base.establish_connection(
    adapter: 'mysql2',
    host: 'localhost',
    username: 'developer',
    password: 'Pakistan#123',
    database: 'db01'
  )
class LawyerStatus < ActiveRecord::Base
    self.table_name="lawyer_status"
    def self.add_new(data_dict)
        LawyerStatus.create(data_dict)
    end
end
## Injected code
u = URI.parse("https://portal.ncbar.gov/Verification/results.aspx")
req = Net::HTTP::Get.new(u)
req["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
req["Accept-Language"] = "en-US,en;q=0.9"
req["Cache-Control"] = "max-age=0"
req["Connection"] = "keep-alive"
req["Cookie"] = "ASP.NET_SessionId=vliir4y4gye325jtbu0jzxuv"
req["Sec-Fetch-Dest"] = "document"
req["Sec-Fetch-Mode"] = "navigate"
req["Sec-Fetch-Site"] = "none"
req["Sec-Fetch-User"] = "?1"
req["Upgrade-Insecure-reqs"] = "1"
req["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36"
req["Sec-Ch-Ua"] = "\"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\""
req["Sec-Ch-Ua-Mobile"] = "?0"
req["Sec-Ch-Ua-Platform"] = "\"Linux\""

req_opt = {
  use_ssl: u.scheme == "https",
}

res = Net::HTTP.start(u.hostname, u.port, req_opt) do |http|
  http.request(req)
end

# res.code
list = []
doc = Nokogiri::HTML(res.body)
records = doc.css("table.table-hover")
records.css("tr").each_with_index do |record , i|
    texts = record.css("td").text.strip.split(/[a-zA-Z]/)[0]
    list[i] = texts
end
n_l = list.compact
# puts n_l
for i in n_l        
## Injected code
  uri = URI.parse("https://portal.ncbar.gov/Verification/viewer.aspx?ID=#{i}")
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
  request["Accept-Language"] = "en-US,en;q=0.9"
  request["Cache-Control"] = "max-age=0"
  request["Connection"] = "keep-alive"
  request["Cookie"] = "ASP.NET_SessionId=vliir4y4gye325jtbu0jzxuv"
  request["Referer"] = "https://portal.ncbar.gov/Verification/results.aspx"
  request["Sec-Fetch-Dest"] = "document"
  request["Sec-Fetch-Mode"] = "navigate"
  request["Sec-Fetch-Site"] = "same-origin"
  request["Sec-Fetch-User"] = "?1"
  request["Upgrade-Insecure-Requests"] = "1"
  request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36"
  request["Sec-Ch-Ua"] = "\"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\""
  request["Sec-Ch-Ua-Mobile"] = "?0"
  request["Sec-Ch-Ua-Platform"] = "\"Linux\""

  req_options = {
  use_ssl: uri.scheme == "https",
  }
  puts "A"
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  puts "B"
  mappings = {
    "bar_#" => "bar",
    "name" => "name",
    "link" => "link",
    "law_firm_name" => "law_firm_name",
    "address" => "law_firm_address",
    "city" => "law_firm_city",
    "zip_code" => "law_firm_zip",
    "state" => "law_firm_state",
    "work_phone" => "phone",
    "email" => "email",
    "status" => "status",
    "date_admitted" => "date_admitted",
    "status_date" => "status_date",
    "judicial_district" => "judicial_district",
    "board_certified_in" => "board_certified"
  }
    doc = Nokogiri::HTML(response.body)
    records = doc.css("div.col-md-5 , div.col-md-7")
    records1 = doc.css("div.panel-heading").text.split("-").last
    hash = {}
    hash[:law_firm_name] = records1
    hash[:link] = "https://portal.ncbar.gov/Verification/viewer.aspx?ID=#{i}"
    puts "D"
    puts hash[:links]
    records.css("dt").each_with_index do |record , i|
        text = record.text.strip.gsub("\t\r\n", "")
        colon_index = text.index(":")
        next unless colon_index # skip if colon_index is nil
        key = text[0..colon_index-1].downcase.strip.gsub(" ", "_").to_sym
        value = records.css("dd")[i].text.strip.gsub(/[\t \r \n ]/, "-").gsub(/[-]/ , " ")
        hash[key] = value
    end
    puts "#{i}"
        # ...
    hash = {}
    hash[:law_firm_name] = records1
    hash[:link] = "https://portal.ncbar.gov/Verification/viewer.aspx?ID=24806"
      
    records.css("dt").each_with_index do |record , i|
      text = record.text.strip.gsub("\t\r\n", "")
      colon_index = text.index(":")
      next unless colon_index # skip if colon_index is nil
      key = text[0..colon_index-1].downcase.strip.gsub(" ", "_").to_sym
      value = records.css("dd")[i].text.strip.gsub(/[\t \r \n ]/, "-").gsub(/[-]/ , " ")
      hash[key] = value
      puts hash
    end
        # ...
    # full_data = hash.transform_keys { |k| mappings[k.to_s] }.compact
    # LawyerStatus.add_new(full_data)
end

  
# hash.delete(nil)


