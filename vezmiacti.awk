BEGIN {
    print "BEGIN:VCALENDAR"
    print "PRODID:-"
    print "VERSION:2.0"
    print "METHOD:PUBLISH"
    FS=";" # .csv separated by ";"
    OFS="" # don't separate output fields
}

/^Předmět/ {
    # head - skip
}

! /^Předmět/ {
    # non-head
    dt_begin = gensub(/([[:digit:]]+).([[:digit:]]+).([[:digit:]]+)/, "\\3\\2\\1", "g", $2) # convert to YYYYMMDD form
    dt_end = gensub(/([[:digit:]]+).([[:digit:]]+).([[:digit:]]+)/, "\\3\\2\\1", "g", $4) # convert to YYYYMMDD form
    url = $16
    print "BEGIN:VEVENT"
    print "URL:", url
    print "DTSTART;TZID=Europe/Prague;VALUE=DATE:", dt_begin
    print "DTEND;TZID=Europe/Prague;VALUE=DATE:", dt_end
    print "SUMMARY:",$1
    print "DESCRIPTION:", url
    print "CLASS:PUBLIC"
    print "TRANSP:TRANSPARENT"
    #print "SEQUENCE:1"
    print "UID:", "vezmi-a-cti-", dt_begin
    print "END:VEVENT"
}

END {
    print "END:VCALENDAR"
}
