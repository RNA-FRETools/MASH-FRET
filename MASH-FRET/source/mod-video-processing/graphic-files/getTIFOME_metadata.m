function [expT,lord,laserWl] = getTIFOME_metadata(omeMeta)
% [expT,lord,laserWl] = getTIFOME_metadata(str)
%
% Retrieve video sampling time, recording order and laser wavelength from
% OME TIF faile' metadata obtained with reader.getMetadataStore()
% Sampling time is calculated as the difference between the time stamps of two successive image recordings.
%
% omeMeta: OME metadata object
% expT: sampling time
% lord: frame indexes ordered according to record time stamp
% laserWl: laser wavelength ordered according to time of appearance

% Get counts
numPlanes = omeMeta.getPlaneCount(0);
numChannels = omeMeta.getPixelsSizeC(0).getValue();

% 1. Extract DeltaT (t) and TheC (laserid)
t = zeros(1, numPlanes);
laserid = zeros(1, numPlanes);

for i = 0:(numPlanes-1)
    % DeltaT
    dt = omeMeta.getPlaneDeltaT(0, i);
    if ~isempty(dt)
        t(i+1) = dt.value().doubleValue();
    end
    
    % TheC
    c = omeMeta.getPlaneTheC(0, i);
    if ~isempty(c)
        laserid(i+1) = c.getValue();
    end
end

% 2. Extract Laser Wavelengths from Channel Names
laserWl = [];
for c = 0:(numChannels-1)
    chName = char(omeMeta.getChannelName(0, c));
    if contains(chName, 'TIRF')
        % Extract the number before ' TIRF'
        wl = str2double(strrep(chName, ' TIRF', ''));
        laserWl = [laserWl, wl];
    end
end

% 3. Calculate outputs exactly as your original script did
[t, lord] = sort(t, 'ascend');

if ~isempty(laserid)
    laserid = laserid(lord) + 1; % Convert to 1-based indexing
    nLaser = numel(unique(laserid));
    if numel(laserWl) == nLaser
        laserWl = laserWl(1:nLaser);
    else
        laserWl = [];
    end
end

% Note: t(2)-t(1) is the Cycle Time (sampling time), not the actual Camera Exposure time
expT = t(2) - t(1); 

