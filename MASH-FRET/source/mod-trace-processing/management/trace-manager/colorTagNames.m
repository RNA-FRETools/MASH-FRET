function str_lst = colorTagNames(h_fig)
% Defines colored strings for popupmenus listing tag names

% Last update by MH, 24.4.2019
% >> fetch tag colors in project parameters
% >> remove "unlabelled" tag
%
% Created by FS, 24.4.2018
%
%

h = guidata(h_fig);

% modified by MH, 24.4.2019
% colorlist = {'transparent', '#4298B5', '#DD5F32', '#92B06A', '#ADC4CC', '#E19D29'};
colorlist = h.tm.molTagClr;

% added by MH, 24.4.2019
nTag = numel(h.tm.molTagNames);
if nTag==0
    str_lst = {'no default tag'};
    return;
end

str_lst = cell(1,nTag+1);

% cancelled by MH, 24.4.2019
% str_lst{1} = h.tm.molTagNames{1};

% modified by MH, 24.4.2019
% for k = 2:length(h.tm.molTagNames)
str_lst{1} = 'select tag';
for k = 2:nTag+1
    if sum(double((hex2rgb(colorlist{k-1})/255)>0.5))==3
        fntClr = 'black';
    else
        fntClr = 'white';
    end
    str_lst{k} = ['<html><body  bgcolor="' colorlist{k-1} '">' ...
        '<font color="',fntClr,'">' h.tm.molTagNames{k-1} ...
        '</font></body></html>'];
end

