function data = getFile2sub(str_prompt, h_fig, varargin)
% Store data of image file to substract for background correction
% "h_fig" >> MASH figure handle
% "data" >> structure containing image information

% Requires external functions: updateActPan, getFrames.
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

data = [];

if ~isempty(varargin)
    file2sub = varargin{1};
else
    [fname, pname, o] = uigetfile({ ...
        '*.sif;*.sira;*.tif;*.gif;*.png;*.spe;*.pma', ...
        ['Supported Graphic File Format' ...
        '(*.sif,*.sira,*.tif,*.gif,*.png,*.spe,*.pma)'];
        '*.sif', 'Andor Solis Simple Interaction File Format(*.sif)'; ...
        '*.sira', 'SIRA Graphic File Format(*.sira)'; ...
        '*.tif', 'Tagged Image File Format(*.tif)'; ...
        '*.gif', 'Graphics Interchange Format(*.gif)'; ...
        '*.png', 'Portable Network Graphics(*.png)'; ...
        '*.spe', 'SPE binary File Format(*.spe)'; ...
        '*.pma', 'PMA binary File Format(*.pma)'; ...
        '*.*', 'All File Format(*.*)';}, str_prompt);
    
    file2sub = [pname, fname];
    
    if isempty(file2sub) || sum(file2sub)==0
        return
    end
    
    cd(pname);
    updateActPan(['First frame of image file ' fname ' from folder:\n' ...
        pname '\nloading for subtraction...'], h_fig);
end
    
[data,ok] = getFrames(file2sub, 1, [], h_fig, false);
if ~ok
    return
end

data.file = file2sub;



