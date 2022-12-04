function [expT,lord,laserWl] = getTIFOME_metadata(str)
% [expT,lord,laserWl] = getTIFOME_metadata(str)
%
% Retrieve video sampling time, recording order and laser wavelength from TIF file XML metadata.
% Sampling time is calculated as the difference between the time stamps of two successive image recordings.
% Image recordings are written within XML tags "<ONE:Plane .../>" and time stamps are assigned to properties "DeltaT"
%
% str: metadata string
% expT: sampling time
% lord: frame indexes ordered according to record time stamp
% laserWl: laser wavelength ordered according to time of appearance

% Created by MH, 11.2.2021

% read data from file
% file = 'C:\Users\mimi\Documents\MyDataFolder\new_setup\ImageDescription.xml';
% f = fopen(file,'r');
% while ~feof(f)
%     fline = fgetl(f);
%     if contains(fline,'<OME:Plane')
%         planes{1} = fline;
%         planes{2} = fgetl(f);
%         break
%     end
% end
% fclose(f);

% read time stamps and lase wavelengths from xml data
strl = split(str,sprintf('\n'));
S = numel(strl);
planes = {};
t = [];
laserid = [];
laserWl = [];
for s = 1:S
    if contains(strl{s},'<OME:Plane')
        planes = cat(2,planes,strl{s});
        t = cat(2,t,str2num(extrOMEProp(strl{s},'DeltaT')));
        laserid = cat(2,laserid,str2num(extrOMEProp(strl{s},'TheC')));
    end
    if contains(strl{s},'<OME:Channel')
        lasername = extrOMEProp(strl{s},'Name');
        if contains(lasername,'TIRF')
            laserWl = cat(2,laserWl,...
                str2num(lasername(1:(end-length('TIRF')))));
        end
    end
end

% retrieve frame order
[t,lord] = sort(t,'ascend');

% retrieve laser order
if ~isempty(laserid)
    laserid = laserid(lord)+1;
    nLaser = numel(unique(laserid));
    if numel(laserWl)==nLaser
        laserWl = laserWl(laserid);
        laserWl = laserWl(1:nLaser);
    else
        laserWl = [];
    end
else
    laserWl = [];
end

% calculate sampling time
expT = t(2)-t(1);


function prop = extrOMEProp(str,propname)

pos = strfind(str,[propname,'=']);
char1 = pos+length([propname,'="']);
pos = strfind(str(char1:end),'"')+char1-1;
char2 = pos(1)-1;
prop = str(char1:char2);
