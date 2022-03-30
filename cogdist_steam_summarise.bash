#!/bin/bash
#  summarise the csv file output from Tarquin

tarquin_dir='/home/sapje1/scratch_sapje1/projects/396_cogdist/steam/analysis/tarquin/'
summary_dir='/home/sapje1/scratch_sapje1/projects/396_cogdist/steam/analysis/summary/'

if [ ! -d $summary_dir ] ; then
    mkdir $summary_dir
fi

echo "Metabolite concentration ratios" > $summary_dir/met_conc.dat
echo "Filename, tCr, tNAA, tCho, tNAA/tCr, tCho/tCr" >> $summary_dir/met_conc.dat

echo "Metabolite CRLBs" > $summary_dir/met_crlb.dat
echo "Filename, CRLB(tCr), CRLB(tNAA), CRLB(tCho)" >> $summary_dir/met_crlb.dat

echo "QA Parameters" > $summary_dir/met_QA.dat
echo "Filename, SNR, FWHM (Hz)" >> $summary_dir/met_QA.dat

for csv_file in ${tarquin_dir}*.csv ; do
    # row2=conc_au labels
    #awk -F, 'NR==2 {print $33", "$31 ", " $32}' ${csv_file}
    # row3=conc_au; field33=TCr, field31=tNAA, field32=tCho
    awk -F, 'NR==3 {print FILENAME", "$33", "$31 ", " $32", "$31 / $33", "$32 / $33}' ${csv_file} >> $summary_dir/met_conc.dat
    # row6=crlbs
    awk -F, 'NR==6 {print FILENAME", "$33", "$31 ", " $32}' ${csv_file} >> $summary_dir/met_crlb.dat
    # row9=QA, field9=fwhm_Hz, field15=SNR
    awk -F, 'NR==9 {print FILENAME", "$9", "$10}' $csv_file >> $summary_dir/met_QA.dat
done

# tidy up the participant labels
cat $summary_dir/met_QA.dat | awk -F '/' '{print $NF}' | awk -F '-1_3_12_2_1107_5_2_43_66075.csv' '{print $1 $2}'  > $summary_dir/met_QA_short.dat
cat $summary_dir/met_conc.dat | awk -F '/' '{print $NF}' | awk -F '-1_3_12_2_1107_5_2_43_66075.csv' '{print $1 $2}'  > $summary_dir/met_conc_short.dat
cat $summary_dir/met_crlb.dat | awk -F '/' '{print $NF}' | awk -F '-1_3_12_2_1107_5_2_43_66075.csv' '{print $1 $2}'  > $summary_dir/met_crlb_short.dat

