#!/usr/bin/ruby

#!/opt/local/bin/ruby -w

extensions = Hash.new{|hash,key| hash[key] = [] }

ARGV.each{|filename|
	ext = File.extname(filename)
	if extensions.key? ext then
		extensions[ext] << filename
	else
		extensions[ext] = [filename]
	end
}

max = extensions.map{|_,files| files.size }.max

extensions.keys.sort.each{|ext|
	files = extensions[ext].sort
	files_list = files.size > 3 ? files[0..3].join(',')+',...' : files.join(',')

	size = files.size
	bar = ('=' * size) + (' ' * (max - size))
	puts "*#{ext}\t:[#{bar}] (#{files_list})"
}
