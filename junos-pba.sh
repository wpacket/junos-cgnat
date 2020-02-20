#!/bin/bash

echo ""
if [ $# -ne 1 ]; then
  echo "------------------------------------------------------------------------------------------"
  echo "1) On the SRX run : show security nat source port-block pool xxx node xxx | save table.txt"
  echo "2) Export the table.txt file on your Laptop'"
  echo "3) Use : pba.sh table.txt"
  echo "------------------------------------------------------------------------------------------"
  echo ""
  exit 1
fi


inputfile=$1

if [ -f $inputfile ];
then

	echo "------------------------------------------"
	echo "Subscriber statistics"
	echo "------------------------------------------"
	subscriber=$(cat $inputfile | cut -c1-18 | grep '^[0-9]' | sort | uniq -c | wc -l)
	echo "Total Number of subscriber :" $subscriber
	echo "------------------------------------------"

	blocks=$(cat $inputfile | cut -c1-18 | sort | uniq -c | grep '.*8 [0-9]'| wc -l)
	percent=$(expr $blocks \* 100 / $subscriber)
	echo "Subscriber using 8 blocks :" $blocks "("$percent"%)"
	
	blocks=$(cat $inputfile | cut -c1-18 | sort | uniq -c | grep '.*7 [0-9]'| wc -l)
	percent=$(expr $blocks \* 100 / $subscriber)
	echo "Subscriber using 7 blocks :" $blocks "("$percent"%)"
	
	blocks=$(cat $inputfile | cut -c1-18 | sort | uniq -c | grep '.*6 [0-9]'| wc -l)
	percent=$(expr $blocks \* 100 / $subscriber)
	echo "Subscriber using 6 blocks :" $blocks "("$percent"%)"
	
	blocks=$(cat $inputfile | cut -c1-18 | sort | uniq -c | grep '.*5 [0-9]'| wc -l)
	percent=$(expr $blocks \* 100 / $subscriber)
	echo "Subscriber using 5 blocks :" $blocks "("$percent"%)"
	
	blocks=$(cat $inputfile | cut -c1-18 | sort | uniq -c | grep '.*4 [0-9]'| wc -l)
	percent=$(expr $blocks \* 100 / $subscriber)
	echo "Subscriber using 4 blocks :" $blocks "("$percent"%)"
	
	blocks=$(cat $inputfile | cut -c1-18 | sort | uniq -c | grep '.*3 [0-9]'| wc -l)
	percent=$(expr $blocks \* 100 / $subscriber)
	echo "Subscriber using 3 blocks :" $blocks "("$percent"%)"
	
	blocks=$(cat $inputfile | cut -c1-18 | sort | uniq -c | grep '.*2 [0-9]'| wc -l)
	percent=$(expr $blocks \* 100 / $subscriber)
	echo "Subscriber using 2 blocks :" $blocks "("$percent"%)"
	
	blocks=$(cat $inputfile | cut -c1-18 | sort | uniq -c | grep '.*1 [0-9]'| wc -l)
	percent=$(expr $blocks \* 100 / $subscriber)
	echo "Subscriber using 1 blocks :" $blocks "("$percent"%)"
	echo ""
	
	echo "------------------------------------------"
	echo "Ports statistics"
	echo "------------------------------------------"
	totalport=$(awk -F " " '{print $1,$4}' $inputfile | rev | cut -c 7- | rev | sort | grep '^[0-9]' | awk -F " " '{sumCPT += $2}; END {{print sumCPT}}')
	echo "Total number of port allocated:"$totalport
	portaverage=$(expr $totalport / $subscriber)
	echo "Average number of port per subscriber:"$portaverage
	echo ""
	
	echo "------------------------------------------"
	echo "Block statistics"
	echo "------------------------------------------"
	usedblock=$( grep 'Used/total port blocks:' $inputfile | sed 's/Used\/total port blocks: //g' | awk -F "/" '{print $1}')
	totalblock=$( grep 'Used/total port blocks:' $inputfile | sed 's/Used\/total port blocks: //g' | awk -F "/" '{print $2}')
	echo "Total number of block allocated:"$usedblock
	echo "Total number of possible block:"$totalblock
	percentB=$(expr $usedblock \* 100 / $totalblock)
	echo "Block usage:"$percentB"%"
	echo ""
	
	awk -F " " '{print $1,$4}' $inputfile | rev | cut -c 7- | rev | sort | grep '^[0-9]'> ./tmp
	
	echo "-------------------------------"
	echo "Top 10 Subscriber ( IP/N ports) "
	echo "-------------------------------"
	
	awk -F " " '{print $1,$4}' $inputfile | rev | cut -c 7- | rev | sort | grep '^[0-9]' | awk -F " " '{sumCPT[$1] += $2}; END {for (id in sumCPT) {print id, sumCPT[id]}}' < ./tmp  | sort -nrk 2 | sed -e "s/ /\//g" | head -n 10
	echo ""
	
	echo "------------------------------"
	echo "Top 10 Subscriber using 8 blocks "
	echo "------------------------------"
	
	cat $inputfile |  cut -c1-18 | sort | uniq -c | grep '.*8 [0-9]' | sed -e "s/      //g" |  awk -F " " '{print $2}' | head -n 10
	echo ""
	awk -F " " '{print $1,$4}' $inputfile | rev | cut -c 7- | rev | sort | grep '^[0-9]' | awk -F " " '{sumCPT[$1] += $2}; END {for (id in sumCPT) {print id, sumCPT[id]}}' < ./tmp  | sort -nk 2 | sed -e "s/ /,/g"  > $inputfile.csv
	rm ./tmp
	
else
   echo "File $inputfile does not exist."
   echo ""
   exit 1
fi









