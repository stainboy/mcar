#!/usr/bin/env bash
# set -x

function capture {
    local raw=$1
    local regex='<a href="([^"]+)"[^>]*>([^<]+)<\/a>'
    if [[ $raw =~ $regex ]]; then
        echo "${BASH_REMATCH[2]} -> ${BASH_REMATCH[1]}"
    fi
}

function refresh {
    echo "processing $1..."

    curl -s $2 |\
     iconv -c -f gb2312 -t utf-8 |\
     grep '熟肉百度网盘' > tmp.html

    rm -f $1.txt
    while IFS='' read -r line || [[ -n "$line" ]]; do
        capture "$line" >> $1.txt
    done < tmp.html
}

while true; do
    date
    while IFS='' read -r line || [[ -n "$line" ]]; do
        eval "refresh $line"
    done < show

    if [[ `git status --porcelain` ]]; then
        echo 'changed, ready to submit code...'
        git commit -a -m 'updated by robot'
        git push origin master
    fi

    date
    sleep 1d
done
