#!/bin/bash
# wand_fix_rrecon_header INPUTDCM.dcm
#   change the header info from a retro recon 7T WAND MP2RAGE to put the participant and
#   study info in the correct fields.
#   uses;
#     /cubric/software/afni/dicom_hdr 
#     /cubric/software/dcmtk/bin/dcmodify
#   cje June 2022


#dcmfile='1.3.12.2.1107.5.2.34.18984.30000022050413495939000005346-39-1-1s0w6i5.dcm'
dcmfile=$1

echo "Before...."
echo $dcmfile
dicom_hdr $dcmfile | grep '0010 0010'   # patient id
dicom_hdr $dcmfile | grep '0010 0020'   # 'patient id' = session id.
# these two are fixed across the project
dicom_hdr $dcmfile | grep '0040 0254'   # protocol folder
dicom_hdr $dcmfile | grep '0008 1030'   # project id
dicom_hdr $dcmfile | grep '0020 0011'   # series no
ismag=`dicom_hdr $dcmfile | grep "_MAG$"`

if [ "${#ismag}" -gt 0 ];  # if ismag length is non-zero
then
   echo "it's magnitude"
   series_no=300
else
   echo "it's phase"
   series_no=301	
fi

# grab ppt_id, session_id
ppt_id=`dicom_hdr ${dcmfile} | grep ^314_ | sed s/'\.'/_/g | sed s/:/_/g | awk -F/ '{print $1}'`
sess_id=`dicom_hdr ${dcmfile} | grep ^314_ | sed s/'\.'/_/g | sed s/:/_/g | awk -F/ '{print $3}'`

#ppt_id
dcmodify -m 0010,0010=${ppt_id} ${dcmfile}
dcmodify -m 0010,0020=${sess_id} ${dcmfile}
dcmodify -m 0008,1030='314_WAND' ${dcmfile}
dcmodify -m 0020,0011=${series_no} ${dcmfile}

#dcmodify -m 0040,0254='7Tproj^314_WAND' ${dcmfile}

echo "After..."
dicom_hdr $dcmfile | grep '0010 0010'   # patient id
#dicom_hdr $dcmfile | grep '0040 0254'   # protocol folder
dicom_hdr $dcmfile | grep '0008 1030'   # project id
dicom_hdr $dcmfile | grep '0010 0020'   # 'patient id' = session id.
dicom_hdr $dcmfile | grep '0020 0011'   # series no

