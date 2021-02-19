function [expT,lord,exc] = getTIFOME_metadata(str)
% [expT,lord,exc] = getTIFOME_metadata(str)
%
% Retrieve video sampling time, recording order and laser wavelength from TIF file XML metadata.
% Sampling time is calculated as the difference between the time stamps of two successive image recordings.
% Image recordings are written within XML tags "<ONE:Plane .../>" and time stamps are assigned to properties "DeltaT"
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
exc = [];
for s = 1:S
    if contains(strl{s},'<OME:Plane')
        planes = cat(2,planes,strl{s});
        t = cat(2,t,str2num(extrPlaneProp(strl{s},'DeltaT')));
    end
end

% retrieve frame order
[t,lord] = sort(t,'ascend');

% calculate sampling time
expT = t(2)-t(1);


function prop = extrPlaneProp(str,propname)

pos = strfind(str,[propname,'=']);
char1 = pos+length([propname,'="']);
pos = strfind(str(char1:end),'"')+char1-1;
char2 = pos(1)-1;
prop = str(char1:char2);
