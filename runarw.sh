  dir="./WRF_v42_sept15_NLCD"
  domain="01"
  outname="wrfout_d${domain}.arl"
  
  #Clean up any old files
  rm -f WRFDATA.ARL
  rm -f ARWDATA.CFG
  rm -f ARLDATA.CFG
  rm -f ${outname}

  #Loop through our WRF output files
  for dd in 05 06 07 08 09 10 11 12; do
  for hh in 00 01 02 03 04 05 06 07 08 09 10 11 12 \
            13 14 15 16 17 18 19 20 21 22 23; do
 
      if [ -f ${dir}/wrfout_d${domain}_2015-09-${dd}_${hh}:00:00 ];then
         rm -f ARLDATA.BIN
         ./arw2arl -i${dir}/wrfout_d${domain}_2015-09-${dd}_${hh}:00:00 -c2 
         cat ARLDATA.BIN >> WRFDATA.ARL 
      fi

  done 
  done

  rm -f ARLDATA.BIN
  rm -f WRFRAIN.BIN 

  #Rename output filename 
  mv WRFDATA.ARL ${outname}
