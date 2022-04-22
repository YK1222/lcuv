#!/bin/zsh
m=$(echo "51\n57\n60\n65")
c=$(echo "2\n3\n4\n5")
lw=5
count=0
echo "リストが入ったファイルを入れる"
read listfile
echo "file\ttitle" > plotlist.txt


echo "set xrange [3:16]\nset yrange [:]\nset ytics format \"%.1t{/Symbol=12 \264}10^{%T}\"\nset grid" > plotscript.pl

while read line;
do
	if [ "${line}" != "" ];
	then
		echo $line >> plotlist.txt
	elif [ "${line}" = "" ];
	then
		count=$((count+1))
		echo $count
for ch in $(echo $c);
do
	file=$(find . -name $(awk -F '\t' 'NR == 2 {print $1}' plotlist.txt))
	title=$(awk -F '\t' 'NR == 2 {print $2}' plotlist.txt)
	echo "plot \"${file}\" u 1:(\$${ch}+0)  title \"${title}\" w l lw ${lw}" >> plotscript.pl
	if [ "${ch}" = 2 ];
	then
		offzero=500000
	elif [ "${ch}" = 5 ];
	then
		offzero=12500
	else
		offzero=100000
	fi
	off=$offzero

	tail -n +3 plotlist.txt | while read line;
	do
		file=$(find . -name $(echo $line | awk -F '\t' '{print $1}'))
		title=$(echo $line | awk -F '\t' '{print $2}')
		echo "replot \"${file}\" u 1:(\$${ch}+${off})  title \"${title}\" w l lw ${lw}" >> plotscript.pl
		off=$((off+offzero))
	done
	
	if [ "${ch}" = 2 ];
	then
		length=210
	elif [ "${ch}" = 3 ];
	then
		length=254
	elif [ "${ch}" = 4 ];
	then
		length=350
	elif [ "${ch}" = 5 ];
	then
		length=400	
	fi
	echo "set title \"UV Chromatogram (ここにタイトルを入れてください, ${length} nm)\"\nset ylabel \"Intensity\"\nset xlabel \"Time (min)\"\nset key outside bottom Left noreverse spacing 1.3 invert\nset xtics 0, 1, 15\nset zeroaxis ls -1\nunset xzeroaxis\nset term pdfcairo color size 7.17in, 5.06in lw 0.25 rounded\nset output \"${count}_$((ch-1)).pdf\"\nreplot\nunset terminal\nset xrange [3:13]\nset yrange [:]\nset ytics format \"%.1t{/Symbol=12 \264}10^{%T}\"\nset grid" >> plotscript.pl
	
	done 
	rm plotlist.txt
	echo "file\ttitle" > plotlist.txt
	fi
done <$listfile
	gnuplot plotscript.pl