BEGIN {
	FS = ","
}

{
	if ($1 !~ /^#/ && $3 ~ /^\+/) { p += $3 }
	if ($1 !~ /^#/ && $3 ~ /^\-/) { m += $3 }
	if ($1 !~ /^#/ && $3 ~ /^\-/) { sum[$2] += $3 }
}

END {
	print "income\t\t" p
	print "--------------------------"
	for (name in sum) {
		print name "\t\t" abs(sum[name])
		#printf("%10s :\t%d\n", name, abs(sum[name]))
	}
	print "--------------------------"
	#print "+ " p, "- " abs(m), "= " p+m
	print " - \t\t" abs(m)
	print "rest\t\t" p + m
}

function abs(x)
{
	return (x < 0)? -x : x
}
