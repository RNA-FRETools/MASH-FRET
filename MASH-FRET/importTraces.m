function [dataAll,pname,fnames] = importTraces(varargin)

dataAll = [];
headers = {'time at532nm','I_1 at532nm','I_2 at532nm', ...
    'FRET_1>2'};
H = size(headers,2);

[fnames,pname] = uigetfile({'*.txt','Text Files(*.txt)'; ...
    '*.*','All Files(*.*)'},'','','MultiSelect','on');

if isequal(fnames,0) || isequal(pname,0)
    return;
else
    cd(pname);
end

if ~iscell(fnames)
    fnames = {fnames};
end

F = size(fnames,2);
dataAll = cell(1,F);

for f = 1:F
    dummy = importdata(cat(2,pname,fnames{f}),'\t',1);
    fid = fopen(cat(2,pname,fnames{f}),'r');
    hd = fgetl(fid);
    fclose(fid);
    tabs = find(uint8(hd)==9);
    tabs = cat(2,0,tabs);
    
    T = size(tabs,2);
    hdcol = cell(1,T-1);
    for t = 1:T-1
        hdcol{t} = hd(tabs(t)+1:tabs(t+1)-1);
    end
    
    col = zeros(1,H);
    for h = 1:H
        B = ~cellfun('isempty',strfind(hdcol,headers{h}));
        B = find(B);
        col(h) = B(1);
    end
    dataAll{f} = dummy.data(:,col);
end