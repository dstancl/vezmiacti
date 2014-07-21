#!/bin/bash

# Získání dat
function get
{
    cd /media/card/www/cgi-bin
    ./vac.sh $1
}

CMD=
# Zjištění parametrů
p=`echo "$QUERY_STRING" | sed -e "s/&/\n/g"`

for I in $p; do
    VAR=`echo "$I" | sed -e "s/\([A-Za-z_][0-9A-Za-z_]*\)=.*/\1/g"`
    VAL=`echo "$I" | sed -e "s/[^=]*=\(.*\)/\1/g"`
    case "$VAR" in
        d)
            CMD="$CMD -d $VAL"
            ;;
    esac
done

# CGI hlavička
echo "Content-Type: text/html"
echo

# Generování HTML hlavičky
cat <<EOT
<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=UTF-8">
<title>Vezmi a čti</title>
</head>
<body>
EOT

# Zobrazení výsledku
get $CMD | awk '
BEGIN { OFS=""; tit=""; }
/Pro den/ { print "<p>", $0; }
/Četba pro/ { print "<h1>", $0, "</h1><p>"; }
/^(.*)([0-9]+):([0-9]*):(.*)/ { match($0, "^(.*):([0-9]+):(.*)", a); if (a[1] != tit) { tit = a[1]; print "</p><h2>", tit, "</h2><p>"; }; print "<sup>", a[2], "</sup> ", a[3]; }
END { print "</p>"; }'

# Generování HTML patičky
cat <<EOT
</body>
</html>
EOT

