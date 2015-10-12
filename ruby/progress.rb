#!/usr/bin/env ruby
# coding: utf-8
$stdout.sync = true #書いておかないと出力がバッファに溜め込まれるかも

def progress_bar(i, max = 100)
  i = i.to_f
  max = max.to_f
  i = max if i > max
  percent = i / max * 100.0
  rest_size = 1 + 5 + 1 # space + progress_num + %
  bar_size = 79 - rest_size # (width - 1) - rest_size
  bar_str = '%-*s' % [bar_size, ('#' * (percent * bar_size / 100).to_i)]
  progress_num = '%3.1f' % percent
  print "\r#{bar_str} #{'%5s' % progress_num}%"
end

(0..1000).each do |j|
  sleep 0.001
  progress_bar(j, 1000)
end
print "\n"
