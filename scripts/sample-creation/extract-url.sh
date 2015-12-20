#!/bin/bash
#Extrahuje dokumenty v WARCů ARCů pomocí jwattools, který dodá URI z připraveného souboru
# Dodaná do patřičného roku, dodaného jako druhý argument,  požadovaný počet extrahovaných souborů.
PWD=$(pwd)
N=$3
WARC_PATH_LIST=$PWD/warcs.txt
CONVERTED_DIR="$PWD"/converted
OUTPUT_DIR="$PWD"/data-new
JWAT="$PWD/"tools/jwat-tools-0.6.0/jwattools.sh

while read line && [[ `find $PWD/data/$2 $PWD/data-new/$2 -name extracted.1 ! -size 0| wc -l` -le 1000 ]]
do
        echo Current working dir is: `pwd`
	URI=`echo "$line"|awk '{print $2}'`
	YEAR=`echo "$line"|awk '{print $1}'`
	WARC=`echo "$line"|awk '{print $NF}'`
	WARC_PATH=`grep -m 1 ^"$WARC" "$WARC_PATH_LIST"|awk '{print $2}'`
	ARC=converted-`echo $WARC|sed -e 's/\.arc\.gz$/\.warc/'`
	DIR="$OUTPUT_DIR"/"$YEAR"/"$WARC"/"$N"
	N=$((N+1))

#	echo "LINE IS $line"
#	echo "WARC IS $WARC"
#	echo "WARC_PATH IS $WARC_PATH"

	case "$WARC" in
		*.arc.gz)
			# If ARC is not converted, convert into WARC.
			if [ ! -s "$ARC" ]; then
                        	echo "Converting $WARC into $CONVERTED_DIR/$ARC"
                        	"$JWAT" arc2warc -d "$CONVERTED_DIR" "$WARC_PATH"
			fi
			mkdir -p "$DIR"
			echo "$line" > "$DIR"/metadata.cdx
			echo "Extracting $URI from converted $WARC to $DIR"
			(cd "$DIR" && "$JWAT" extract -u "$URI" "$CONVERTED_DIR"/"$ARC")
			;;
		*.warc.gz)
			mkdir -p "$DIR"
			echo "$line" > "$DIR"/metadata.cdx
			echo "Extracting $URI from $WARC to $DIR"
			(cd "$DIR" && "$JWAT" extract -u "$URI" "$WARC_PATH")
			;;
	esac
done < $1
