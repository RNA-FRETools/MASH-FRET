function [w_txt,h_txt] = getUItextWidth(str,fntun_out,fntsz_out,fntwt,tbl,varargin)
% Returns the pixel dimensions of a text uicontrol containing a string
% formatted with specific font size and weight.
%
% getUItextWidth(str,fntun_out,fntsz_out,fntwt,tbl)
% getUItextWidth(str,fntun_out,fntsz_out,fntwt,tbl,fntnm_out)
%
% Takes input parameters:
% "str": string contained in text uicontrol
% "fntun_out": font units ('points','pixels','inches' or 'centimeters')
% "fntsz_out": font sizes given in font units
% "fntwt": font weight ('normal' or 'bold')
% "fntnm_out": font name
% "tbl": reference table listing pixel widths of ASCII characters at different font sizes and weights

% default
w_txt = 0;
h_txt = 0;
mg_y = 5/21; % top and bottom padding in relative units

% collect data from reference table
letters_0 = tbl{1};
fntun_0 = tbl{2}{1};
fntsz_0 = tbl{2}{2};
fntnm_0 = tbl{2}{3};
switch fntwt
    case 'normal'
        ind = 1;
    case 'bold'
        ind = 2;
    otherwise
        disp('FAILURE: font weight unknown.');
        return
end

% define font name
if ~isempty(varargin)
    fntnm = get(groot,'defaultuicontrolfontname');
else
    fntnm = fntnm_0{1};
end

% convert font size to table font units
fntsz = convFntun(fntsz_out,fntun_out,fntun_0);

% get reference widths at requested font weight and size
w_0sz = tbl{3}{1,ind}(fntsz_0==fntsz,:,:,contains(fntnm_0,fntnm));
if isempty(w_0sz)
    fprintf(cat(2,'FAILURE: font size %i %s (%i %s) was not found in ',...
        'reference table.\nConsider updating the reference table with new',...
        ' font sizes using the command addFntszToTable (type help ',...
        'addFntszToTable for more information).\n'),fntsz,fntun_0,fntsz_out,...
        fntun_out);
    return
end

% get reference widths at requested font name
w_0 = w_0sz(:,:,:,contains(fntnm_0,fntnm));
if isempty(w_0)
    fprintf(cat(2,'FAILURE: font name %s was not found in reference ',...
        'table.\nConsider updating the reference table with new font ',...
        'names using the command addFntnmToTable (type help ',...
        'addFntnmToTable for more information).\n'),fntnm);
    return
end

% convert font size to pixels
fntsz_pix = convFntun(fntsz_out,fntun_out,'pixels');

% get pixel height of text control
h_txt = (1+mg_y)*fntsz_pix;

% get width of text control including extra space
w_txt = getWidth(str,letters_0,w_0);

% create uicontrol to verrify calculated dimensions:

% h_fig = figure('menubar','none','units','pixels');
% pos0 = get(0,'screensize');
% wfig = 2*w_txt+2;
% hfig = 2*h_txt+2;
% posfig = [(pos0(3)-wfig)/2,(pos0(4)-hfig)/2,wfig,hfig];
% set(h_fig,'position',posfig);
% x = (posfig(3)-w_txt)/2;
% y = (posfig(4)-h_txt)/2;
% uicontrol('style','text','parent',h_fig,'units','pixels','fontunits',...
%     fntun_out,'fontsize',fntsz_out,'fontweight',fntwt,'string',str,...
%     'position',[x,y,w_txt,h_txt],'backgroundcolor',[0,1,0]);


function w = getWidth(str,letters_0,w_0)

w = 0;
L = length(str);
for l = 1:L
    
    % find character index in reference table
    n = find(letters_0==str(l),1);
    if isempty(n)
        fprintf(cat(2,'FAILURE: character %s not found in reference table.\n',...
            'Consider updating the reference table with new characters ',...
            'using the command addCharToTable (type help addCharToTable ',...
            'for more information).\n\n'),str(l));
        return
    end
    n = n(1);
    
    % extend text width with character
    w = w+w_0(1,1,n);
    
    % extend text width with extra space
    if l==1
        w = w+w_0(1,3,n);
    end
    if l==L
        w = w+w_0(1,3,n);
    end
end

