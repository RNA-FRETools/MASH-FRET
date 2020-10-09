function [str,hndls] = wrapStrToWidth(str,fntun,fntsz,fntwt,w,conv,hndls)
% Break a string according to a certain pixel width.
%
% [str,hndls] = wrapStrToWidth(str,fntun,fntsz,fntwt,w,conv,hndls)
%
% Take input parameters:
% str: string to break down
% fntun: font units
% fntsz: font size
% w: text width (in pixels)
% conv: conversion format ('gui' to use cells, 'html' to use <br> tag, 'printf' to use '\n')
% hndls: 1-by-2 or empty array containing figure and text handles
%
% Returns output parameters:
% str: the formatted string
% hndls: 1-by-2 array containing figure and text handles

if isempty(hndls)
    h_fig = figure('visible','off','units','pixels');
    h_txt = uicontrol('style','text','parent',h_fig,'units','pixels');
else
    h_fig = hndls(1);
    h_txt = hndls(2);
end

set(h_txt,'fontunits',fntun,'fontsize',fntsz,'fontweight',fntwt,'string',...
    str,'position',[0,0,w,50]);

outstr = textwrap(h_txt,{str});

str = '';
nLines = numel(outstr);
switch conv
    case 'gui'
        str = outstr';
        
    case 'html'
        for c = 1:nLines
            str = cat(2,str,outstr{c});
            if c<nLines
                str = cat(2,str,'<br>');
            end
        end
        str = cat(2,'<html>',str,'</html>');
        
    case 'printf'
        for c = 1:nLines
            str = cat(2,str,outstr{c});
            if c<nLines
                str = cat(2,str,'\n');
            end
        end
end

hndls = [h_fig,h_txt];

