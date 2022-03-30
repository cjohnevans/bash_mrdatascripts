#!/bin/bash
#   CJE 29/3/2022
#   rename data from XNAT Download Images (Include Subject ON, Simplify OFF)
#   to include series description and scan data

#   Start with this directory structure (from XNAT)
#      PPTID/SCANID/scans/SERIESNO/resources/secondary/FILEID.dcm
#   Aim for this directory structure;
#      PPTID/SCANID/PPTID_SERIESDESC_DATE.dcm

#define the top level directory, paths are relative to this.  Needs trailing '/'
dcm_top_dir='/home/sapje1/scratch_sapje1/projects/396_cogdist/steam/'
dcm_path=$dcm_top_dir"raw/*/*/scans/*/resources/secondary/*.dcm"

if [ -d $dcm_top_dir'sort' ]; then
    echo $dcm_top_dir'sort' "exists.  Removing."
    rm -Ir $dcm_top_dir'sort'
fi

mkdir $dcm_top_dir'sort'

for dcm in $dcm_path;
    # NF is last field. All params relative to the last field.
    do dcm_file=`echo $dcm | awk -F '/' '{print $(NF)}'`
    ppt_id=`echo $dcm | awk -F '/' '{print $(NF-6)}'`
    scan_id=`echo $dcm | awk -F '/' '{print $(NF-5)}'`
    scan_date=`echo $scan_id | awk -F '-' '{print $(1)}'`
    series_desc=`dicom_hdr $dcm | grep "Series Description" | awk -F '//' '{print $(NF)}'`
    new_ppt_dir=$dcm_top_dir"sort/"$ppt_id"/"
    new_scan_dir=$new_ppt_dir"/"$scan_id"/"
    new_file=$ppt_id"__"$scan_date"__"$series_desc".dcm"
    # create directories, if they don't exist from previous pass
    if [ ! -d $new_ppt_dir ]; then
        mkdir $new_ppt_dir
    fi
    if [ ! -d $new_scan_dir ]; then
        mkdir $new_scan_dir
    fi
    echo
    echo "original dcm_file is " $dcm
    echo "new ppt dir is " $new_ppt_dir
    echo "new scan dir is "$new_scan_dir
    #echo "scan_date is "$scan_date
    #echo "series_desc is " $series_desc
    echo "new filename is " $new_file
    cp $dcm ${new_scan_dir}"/"${new_file}
done

