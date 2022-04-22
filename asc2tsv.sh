#!/bin/zsh
echo "asctsv型にするスクリプトforHPLCよう)"
echo "エンターでスタート"
read start
mkdir tsv
mkdir asc
echo time >time.txt
seq 0 0.00666666667 16.001 >> time.txt
for i in $(find . -name "*.asc" );
do
LC_CTYPE=C tr -d '\r' < $i > data.txt
for k in $(seq 8);
do
echo $(basename $i | sed -e 's/.asc//')-CH.$k > $k.txt
sed -n $((17+2401*(k-1))),$((16+2401*k))p data.txt | awk '{if (NR == 1){a=$1;print $1-a}else{print $1-a}}' >> $k.txt
done
paste -d '\t' time.txt 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt 7.txt 8.txt > tsv/$(basename $i | sed -e 's/.asc/.tsv/')
mv $i ./asc
done
rm *.txt