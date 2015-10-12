#!/usr/bin/env ruby
 
require 'nokogiri'
 
def scan_wifi
  xml = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s -x`
  doc = Nokogiri::XML(xml)
  system 'clear'
  puts "## #{Time.now.to_s}"
  results = []
 
  doc.xpath('/plist/array/dict').each do |wifi|
    rssi = ssid = bssid = ""
    wifi.xpath('key').each do |key|
      case key.content
      when "BSSID"
        bssid = key.next.next.content
      when "SSID_STR"
        ssid = key.next.next.content
      when "RSSI"
        rssi = key.next.next.content
      end
    end
 
    results << "#{rssi}:\t#{ssid} (#{bssid})"
  end
  
  puts results.sort
  puts "\n"
end
 
begin 
  while true do
    scan_wifi()
  end
rescue Interrupt
  puts "\ninterrupted! exit scanning."
end
  
