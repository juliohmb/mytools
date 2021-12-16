
#! /bin/bash -x

### args parsing

domain=
outputfile=

usage() { echo "Usage: subenum.sh -d domain.com 
		 [-o] outputfile
		 [-h help]" 1>&2; exit 1; }

while getopts "d:o:h" o; do
    case "${o}" in
        d)
            domain=${OPTARG}
            ;;
        o)
            outputfile=${OPTARG}
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

if [ -z "${domain}" ]; then
   usage
fi

###

output=

echo "enumerating with sublist3r"
if [ -z "${outputfile}" ]; then
   sublist3r -d $domain
else
   sublist3r -d $domain -o $outputfile
fi

echo "Checking certspotter..."
curl -s https://certspotter.com/api/v1/issuances\?domain\=$domain\&expand\=dns_names\&include_subdomains\=true | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain
if [ -z "${outputfile}" ]; then
   curl -s https://certspotter.com/api/v1/issuances\?domain\=$domain\&expand\=dns_names\&include_subdomains\=true | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain
else 
   curl -s https://certspotter.com/api/v1/issuances\?domain\=$domain\&expand\=dns_names\&include_subdomains\=true | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain | anew $outputfile
fi
