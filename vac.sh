#!/bin/bash

# Vezmi a čti
# Rozpis na zadaný den

SOURCECSV="./rozpis_msoutlook.csv"

# Generování odkazů na předchozí, dnešní a zítřejší den
function nav
{
    echo 
}

# Získání dat
# Parametry:
# $1 - den (YYYYMMDD)
function get {
    local D=$1
    local R=`cat "$SOURCECSV" | grep -E "^[^;]*;${D:6:2}\.${D:4:2}\.${D:0:4};.*"`
    echo $R | sed -e "s/^Vezmi a čti \([^;]*\);.*/\1/g"
}

DT=`date +"%Y%m%d"`

# Data z příkazové řádky
while [ "x$1" != "x" ]; do
    case "$1" in
	-d)
	    shift
	    DT=$1
	    ;;
    esac
    shift
done

# Zjištění parametrů
VERSE=`get $DT | sed -e "s/–/-/g"`

if [ "x$VERSE" == "x" ]; then
    echo "Pro den ${DT:6:2}.${DT:4:2}.${DT:0:4} nebylo nalezeno žádné čtení."
else
    echo "Četba pro den ${DT:6:2}.${DT:4:2}.${DT:0:4}: $VERSE"
    diatheke -b CzeCEP -l cs -f plain -k "$VERSE"
fi

