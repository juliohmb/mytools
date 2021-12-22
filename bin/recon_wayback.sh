#! /bin/bash

### args parsing

target=
# fast=
usage() { echo "Usage: recon_wayback.sh -t file.txt
		 [-h help]" 1>&2; exit 1; }

while getopts "t:hf" o; do
    case "${o}" in
        t)
            target=${OPTARG}
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

mkdir wayback_urls

cat $target | waybackurls >> wayback_urls/wayback_output.txt
sort -u wayback_urls/wayback_output.txt
cat wayback_urls/wayback_output.txt | grep '?*=' | sort -u >> wayback_urls/params.txt
for i in $(cat wayback_urls/params.txt);do echo $i'=';done
echo

echo "getting extensions"
mkdir wayback_urls/extensions

echo
echo "extracting .php"
cat wayback_urls/wayback_output.txt | grep ".php" | sort -u >> wayback_urls/extensions/php.txt

echo
echo "extracting .js"
cat wayback_urls/wayback_output.txt | grep ".js" | sort -u >> wayback_urls/extensions/js.txt

echo
echo "extracting .html"
cat wayback_urls/wayback_output.txt | grep ".html" | sort -u >> wayback_urls/extensions/html.txt

echo
echo "extracting .json"
cat wayback_urls/wayback_output.txt | grep ".json" | sort -u >> wayback_urls/extensions/json.txt

echo
echo "extracting .aspx"
cat wayback_urls/wayback_output.txt | grep ".aspx" | sort -u >> wayback_urls/extensions/aspx.txt
