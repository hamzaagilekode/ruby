require 'net/http'
require 'uri'
require "nokogiri"
require "active_record"
require "mysql2"
require "digest"
require "open-uri"
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

uri = URI.parse("https://portal.ncbar.gov/Verification/search.aspx")
request = Net::HTTP::Get.new(uri)
request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
request["Accept-Language"] = "en-US,en;q=0.9"
request["Connection"] = "keep-alive"
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
document = Nokogiri::HTML(response.body)
cookie_response = response.header["Set-Cookie"]
viewstate = document.css("#__VIEWSTATE")[0]["value"]
viewstategenerator = document.css("#__VIEWSTATEGENERATOR")[0]["value"]
eventvalidation = document.css("#__EVENTVALIDATION")[0]["value"]
specialization = document.css("#ddSpecialization") #[0]["value"]


## POST REQUEST


specialization.css("option").each_with_index do |hash ,index|
  next if index == 0
  name = hash.attr("value")
  next if name.downcase == 'n/a'
  uri = URI.parse("https://portal.ncbar.gov/Verification/search.aspx")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/x-www-form-urlencoded"
  request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
  request["Accept-Language"] = "en-US,en;q=0.9"
  request["Cookie"] = cookie_response
  request["Cache-Control"] = "max-age=0"
  request["Connection"] = "keep-alive"
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
  request.set_form_data(
    "__EVENTARGUMENT" => "",
    "__EVENTTARGET" => "",
    "__EVENTVALIDATION" => eventvalidation,
    "__VIEWSTATE" => viewstate,
    "__VIEWSTATEGENERATOR" => viewstategenerator,
    "ctl00$Content$btnSubmit" => "Search",
    "ctl00$Content$ddJudicialDistrict" => "",
    "ctl00$Content$ddLicStatus" => "",
    "ctl00$Content$ddLicType" => "",
    "ctl00$Content$ddSpecialization" => name,
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
  
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  uri = URI.parse("https://portal.ncbar.gov/Verification/results.aspx")
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
  request["Accept-Language"] = "en-US,en;q=0.9"
  request["Cache-Control"] = "max-age=0"
  request["Connection"] = "keep-alive"
  request["Cookie"] = cookie_response
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
  
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  puts "On #{name}"

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

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
  baseurl = "https://portal.ncbar.gov"
  table = doc.css("table.table")
  table.css("td").each{|a|
    my_link=a.css("a")[0]
    if my_link.class!=NilClass
      last_link=my_link["href"]
      link = "#{baseurl}#{last_link}"
      uri = URI.parse(link)
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
      request["Accept-Language"] = "en-US,en;q=0.9"
      request["Cache-Control"] = "max-age=0"
      request["Connection"] = "keep-alive"
      request["Cookie"] = cookie_response
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

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      # puts response.body
      doc = Nokogiri::HTML(response.body)
      records = doc.css("dl.dl-horizontal")
      records1 = doc.css("div.panel-heading").text.split("-").last.gsub("\r\t\n" , "")
      hash = {}
      hash[:law_firm_name] = records1
      hash[:link] = link
      records.css("dt").each_with_index do |record , i|
        text = record.text.strip.gsub("\t\r\n", "")
        colon_index = text.index(":")
        next unless colon_index # skip if colon_index is nil
        key = text[0..colon_index-1].downcase.strip.gsub(" ", "_").to_sym
        value = records.css("dd")[i].text.strip.gsub(/[\t \r \n ]/, "-").gsub(/[-]/ , " ")
        hash[key] = value
        puts hash
      end
      full_data = hash.transform_keys { |k| mappings[k.to_s] }.compact
      LawyerStatus.add_new(full_data)
    #pasted above
    end
  }
  puts "loop completes on #{name}"
  
end
puts "-> CODE SUCCESSFULLY EXECUTED <-"

