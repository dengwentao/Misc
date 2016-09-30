seed = "470001070123915"
seg1 = seed.slice(0, 6).to_i
p seg1
seg2 = seed.slice(6, 4).to_i
p seg2
seg3 = seed.slice(10, 4).to_i
p seg3
seg4 = seed.slice(14, 1).to_i
p seg4

count = 1000
i = 0
checksum100 = 4
while i <count do
	seg2 += 1

	if seg2 % 100 == 0
		seg4 = (checksum100 + 7) % 10
		checksum100 = seg4
	elsif seg2 % 10 == 0
		seg4 = (seg4 + 6) % 10
	else
		seg4 = (seg4 + 7) % 10
	end

	code = sprintf("%06d%04d%04d%01d", seg1, seg2, seg3, seg4)
	p code
	i += 1
end