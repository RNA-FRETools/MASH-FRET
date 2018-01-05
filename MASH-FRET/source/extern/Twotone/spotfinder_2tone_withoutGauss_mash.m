function coordinates_xy = spotfinder_2tone_withoutGauss_mash(dat, BPdiscDiametre, threshD)
  if BPdiscDiametre > 1
    datFilt = bpass(dat,1,BPdiscDiametre);
  %  AFiltered = bpass(A,1,BPdiscDiametre);
  else  % no low pass filtering only high pass for noise
    datFilt = bpass(dat,1,0);
  %  AFiltered = bpass(A,1,0);
  end
    % getting coordinate matrix

coordinates_xy = findLocalMax(datFilt,threshD);