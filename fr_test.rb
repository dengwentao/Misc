require "base64"
require 'json'
require 'net/http'

uri = URI.parse("http://letv-china-ortb.revsci.net/rtbbidder/v1/openrtb/letv")
http = Net::HTTP.new(uri.host, uri.port)
header = {'Content-Type' => 'text/json'}
request = Net::HTTP::Post.new(uri.request_uri, header)

total = 500
test = 0
nobid = 0
bid = 0
strange = 0

uid = 200000

begin
	output = File.open("/Users/wentaod/Desktop/fr_test_result.txt", "w")
	while test < total do
		File.readlines('/Users/wentaod/Desktop/fr_test.txt').each do |line|
			if test == total then
				break;
			end
			plain = Base64.decode64(line)
			hash = JSON.parse(plain)

			if hash.key?("app") || !hash.key?("site") || hash["imp"][0]["pmp"]["private_auction"] != 1
				p plain
				puts "dropped one request"
				next
			end

			hash["imp"][0]["pmp"]["deals"][0]["id"] = 7281601
			hash["user"]["id"] = uid
			uid += 1

			request.body = hash.to_json
			begin
				response = http.request(request)

				if response.code == "204" then
					nobid += 1
				elsif response.code == "200" then
					bid += 1
				else
					strange += 1
				end

			    puts "response #{response.body}"
			    #cmd = 'curl -H "Content-Type: application/json" -d ' + body + ' "http://letv-china-ortb.revsci.net/rtbbidder/v1/openrtb/letv" -i'
				#response = `curl -H "Content-Type: application/json" -d '#{body}' "http://letv-china-ortb.revsci.net/rtbbidder/v1/openrtb/letv" -i`
			rescue => e
		    	puts "failed #{e}"	
			end

			output.puts(request.body + "*****" + response.to_s)
			test += 1
		end
	end # while
rescue IOError => e
  puts e
ensure
  output.close unless output.nil?
end

puts "Total = " + total.to_s + ", nobid = " + nobid.to_s + ", bid = " + bid.to_s + ", strange = " + strange.to_s


