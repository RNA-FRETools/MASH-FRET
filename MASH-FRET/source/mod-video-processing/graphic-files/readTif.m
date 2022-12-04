function [data,ok] = readTif(fullFname, n, fDat, h_fig, useMov)

% defaults
isome = false; % tif file with OME metadata

% identify OME file
info = imfinfo(fullFname); % information array of .tif file

% If the *.tif file has been exported from SIRA, the cycletime is
% stored in ImageDescription field of structure info.
if isfield(info,'ImageDescription')
    descr = info(1,1).ImageDescription;
    if strcmp(descr(1:5),'<?xml')
        isome = true;
    end
end

if isome
    [data,ok] = readTif_OME(fullFname, n, fDat, h_fig, useMov);
else
    [data,ok] = readTif_regular(fullFname, n, fDat, h_fig, useMov);
end
