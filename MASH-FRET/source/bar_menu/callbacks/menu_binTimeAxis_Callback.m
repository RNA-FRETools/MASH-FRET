function menu_binTimeAxis_Callback(obj,evd)

expT = inputdlg('Please define a new time bin (in seconds):',...
    'New time bin');

if isempty(expT)
    return
end

if numel(str2double(expT{1}))~=1
    disp('Bin time is ill defined.');
    return
end

binTrajFiles(str2double(expT{1}));