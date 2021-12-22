
#! /bin/bash

### args parsing

target=
fast=
usage() { echo "Usage: subenum.sh -t domain.com
		 [-h help]" 1>&2; exit 1; }

while getopts "t:hf" o; do
    case "${o}" in
        t)
            target=${OPTARG}
            ;;
				f)
            fast=true
            ;;
				h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND - 1))

if [ -z "${target}" ]; then
   usage
fi

###

echo "enumerating with assetfinder"
mkdir assetfinder
assetfinder $target >> assetfinder/subdomains.txt
cat assetfinder/subdomains.txt | grep $target >> Subdomain_final.txt
echo

echo "enumerating with sublist3r"
mkdir sublist3r
sublist3r -d $target -v -t 100 -o sublist3r/subdomains.txt
cat sublist3r/subdomains.txt | grep $target >> Subdomain_final.txt
echo


if [ $fast != true ]; then
	echo "enumerating with amass"
	mkdir amass
	amass enum -d $target -o amass/subdomains.txt
	cat amass/subdomains.txt | grep $target >> Subdomain_final.txt
	echo
fi

echo "Checking certspotter..."
mkdir certspotter
curl -s https://certspotter.com/api/v1/issuances\?domain\=$target\&expand\=dns_names\&include_subdomains\=true | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $target >> certspotter/subdomains.txt
cat certspotter/subdomains.txt | grep $target >> Subdomain_final.txt

echo "httprobe"
cat Subdomain_final.txt | sort -u | httprobe | sed -E 's/^\s*.*:\/\///g' | sort -u >> alive.txt
echo

echo "taking screenshots"
eyewitness -f alive.txt --web -d eyewitness --resolve
