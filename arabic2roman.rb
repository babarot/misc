#!/usr/bin/env ruby
#encoding: utf-8

def roman_numeral num
	roman = ''
	t = num / 1000
	h = num % 1000 / 100
	tens = num % 100 / 10
	o = num % 10
	roman += 'M' * t
	if h == 9
		roman += 'CM'
	elsif h == 4
		roman += 'CD'
	else
		roman += 'D' * (h / 5)
		roman += 'C' * (h % 5)
	end
	if tens == 9
		roman += 'XC'
	elsif tens == 4
		roman += 'XL'
	else
		roman += 'L' * (tens / 5)
		roman += 'X' * (tens % 5)
	end
	if o == 9
		roman += 'IX' 
	elsif o == 4
		roman += 'IV'
	else
		roman += 'V' * (o / 5)
		roman += 'I' * (o % 5)
	end
	roman
end

(1..3000).each do |num|
	puts "#{num}: #{roman_numeral num}"
end

