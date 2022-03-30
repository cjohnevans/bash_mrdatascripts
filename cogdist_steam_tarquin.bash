#!/bin/bash

dcm_top_dir='/home/sapje1/scratch_sapje1/projects/396_cogdist/steam/sort/'
tarquin_dir='/home/sapje1/scratch_sapje1/projects/396_cogdist/steam/analysis/tarquin/'
tarquin_cmd='/cubric/software/tarquin/tarquin'

if [ ! -d $tarquin_dir ]; then
    mkdir $tarquin_dir
fi

# loop over participant directories
for ppt_dir in $dcm_top_dir/* ; do
    if [ -d $ppt_dir ]; then
        echo $ppt_dir " is dir"
        ppt=`echo $ppt_dir | awk -F '/' '{print $(NF)}'`
        # look for dcm files if subdir (scan) exists
        for scan_dir in $ppt_dir/* ; do
            if [ -d $scan_dir ]; then
                #echo $scan_dir " is dir"
                scan=`echo $scan_dir | awk -F '/' '{print $(NF)}'`
                tarquin_out_name=$tarquin_dir$ppt"__"$scan
                echo $tarquin_out_name
                for thal_dcm in `find ${scan_dir} -name '*lamus_svs_steam.dcm*'` ; do
                    $tarquin_cmd --input $thal_dcm --output_csv ${tarquin_out_name}.csv --output_pdf ${tarquin_out_name}.pdf --ext_pdf true
                done
            fi
        done
    fi
done

mrs_id='300321-401__21_03_30__LeftThalamus_svs_steam'
met_dcm=$mrs_id'.dcm'
wat_dcm=$mrs_id'_ref.dcm'
pdf_name=$mrs_id'.pdf'
csv_name=$mrs_id'.csv'

#/cubric/software/tarquin/tarquin --input $met_dcm --input_w $wat_dcm --output_pdf $pdf_name --ext_pdf true --output_csv $csv_name 
