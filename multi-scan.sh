#!/bin/bash 
duplex=false
scan=true
sargs="--resolution 150 -l 0 -t 0 -x 215 -y 279"
while getopts "df:n:" optname
  do
    case "$optname" in
      "f")
        doc_name=$OPTARG
        ;;
      "d")
        duplex=true
        ;;
      "n")
        num_pages=$OPTARG
        ;;
      "N")
        scan=false
        ;;
       "?")
        echo "Unknown option $OPTARG"
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
  done

echo "Document name: $doc_name"
echo "Number of Pages: $num_pages"
echo "Duplex: $duplex"
echo "Scan: $scan"

if [ -d "$doc_name" ]
then
    echo -n "$doc_name directory exists, delete (Y/n):"
    read d
    if [ $d ]
    then
        if [ $d=="n" ]
        then
           echo "go there"
           exit 1 
        fi
    fi
    echo "Deleting $doc_name"
    rm -rf $doc_name
fi
# create the tmp directory 
mkdir $doc_name
cd $doc_name
dir_name=`basename $(pwd)`
pdf_name="${dir_name}.pdf"
echo "PDF:$pdf_name"

if [ $duplex = true ]
then
    echo "Duplex: $duplex"
    if [ $scan=true ]
    then
        pages_to_scan=$(($num_pages/2))
        echo "pages_to_scan:$pages_to_scan"
        for n in 1 2
        do
            scanimage $sargs -d hpaio:/usb/Officejet_J4500_series?serial=CN89S570KK052T  --batch-double --batch-count=$pages_to_scan --batch-start=$n
            if [ $n == "1" ]
            then
                echo "Reload docs, hit enter to continue.."
                read cont
            fi
        done
    fi    
else
    echo "Single sided"
    scanimage $sargs -d hpaio:/usb/Officejet_J4500_series?serial=CN89S570KK052T  --batch-count=$pages_to_scan --batch-start=1 
fi
files=`ls -ur`
convert $files ../$pdf_name

