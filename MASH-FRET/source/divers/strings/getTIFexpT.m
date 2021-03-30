function expT = getTIFexpT(str)
% expT = getTIFexpT(str)
%
% Retrieve video sampling time from TIF file XML metadata.
% Sampling time is calculated as the difference between the time stamps of
% two successive image recordings.
% Image recordings are written within XML tags "<ONE:Plane .../>" and time 
% stamps are assigned to properties "DeltaT"
% Created by MH, 11.2.2021

planes = cell(1,2);

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

% read data from string
strl = split(str,sprintf('\n'));
S = numel(strl);
for s = 1:S
    if contains(strl{s},'<OME:Plane')
        planes{1} = strl{s};
        planes{2} = strl{s+1};
        break
    end
end

% retrieve time stamps
t1 = str2num(extrPlaneProp(planes{1},'DeltaT'));
t2 = str2num(extrPlaneProp(planes{2},'DeltaT'));

% calculate sampling time
expT = t2-t1;


function prop = extrPlaneProp(str,propname)

pos = strfind(str,[propname,'=']);
char1 = pos+length([propname,'="']);
pos = strfind(str(char1:end),'"')+char1-1;
char2 = pos(1)-1;
prop = str(char1:char2);
