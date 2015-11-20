#Proxy Scraper v0.1
#JoeWHoward on GitHub
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/https'

inputFile = "sources.txt"
outputFile = "out.txt"

counter = 0

File.readlines(inputFile).each do |line|
begin
	page = Nokogiri::HTML(open(line.strip))
	fullText = page.css("body").text.to_s
	ipArray = fullText.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\:[0-9]{1,5}\b/)
    ipArray.each {|x| File.open(outputFile, 'a') {|f| f.write(x + "\n")}}
	counter+=1
rescue OpenURI::HTTPError => e
	if e.message == '404 Not Found'
		puts "#{line} returned a 404 Error"
	else
	end
rescue SocketError
	puts "#{line} returned a SocketError"
rescue Errno::ECONNRESET
	puts "#{line} returned a reset by peer error"
end
end

puts "Pulled proxies from #{counter} sources."
