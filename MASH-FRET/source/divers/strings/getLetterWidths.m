function results = getLetterWidths(letters,fntun,fntsz,fntnm,fntwt)
% Get pixel widths of individual ASCII characters when printed in a figure.
%
% results = getLetterWidths(letters,fntun,fntsz,fntnm,fntwt)
%
% Prints a string containing 5 time the ASCII character in a dummy figure 
% which is then exported to an image file. Pixels in the image are analyzed
% to obtain the average pixel widths of the caharcter and associated
% spaces.
%
% Take input arguments:
% "letters": row vector containing ASCII characters
% "funtun": font units ('points','pixels','inches' or 'centimeters')
% "fntsz": row vector containing fontsizes given in font units
% "fntnm": cell vector containing font names
% "fntwt": font weight ('bold' or 'normal')
%
% Returns "results" as a 1-by-3 cell array with:
% results{1} characters, 
% results{2} a 1-by-2 cell array with:
%   results{2}{1} font units,
%   results{2}{2} font sizes,
% results{3} (nb of font sizes)-by-3-by-(nb of characters)-by-(nb font names) array with:
%   results{3}(sz,1,char,nm) average character + in-between space widths (in pixels),
%   results{3}(sz,2,char,nm) average character height (in pixels),
%   results{3}(sz,3,char,nm) averaged width of spaces at text extremities (in pixels).
%
% example: get width of characters  !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFG
% HIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~using font sizes 
% 3 to 30 points and regular font weight:
%
% widths = getLetterWidths(char(32:127),'points',3:30,'Courier','normal');

% defaults 
nrep = 5; % number of character repetition in text
bg = [0,1,0]; % text background color
name = 'figure.bmp'; % dummy image file
minw = 1; % minimum character width (in pixels)
minw0 = 0; % minimum space widths a text extremities (in pixels)
nbytes = 0; % initializes number action string length

% initialize results
results = {letters,{fntun,fntsz,fntnm},[]};

% check memory
C = length(letters);
S = numel(fntsz);
N = numel(fntnm);
if ~memAlloc(3*C*S*N)
    disp('ERROR: not enough memory available');
    disp('Please retry with fewer characters and/or font sizes.');
    return;
end

% get dummy file path
[pname,o,o] = fileparts(which('getLetterWidths'));
fname = cat(2,pname,filesep,name);

% create dummy figure
h_fig = figure('units','pixels','menubar','none','color','white',...
    'paperpositionmode','auto','visible','off');
h_txt = uicontrol('style','text','parent',h_fig,'units','pixels',...
    'fontunits',fntun,'fontweight',fntwt,'backgroundcolor',bg);

try
    % initializes progess
    prgrss = 0;
    
    % intializes handles
    hndls = [];
    
    for c = 1:C

        % initializes partial font name results
        widths_nm = [];

        % loop over font sizes
        for n = 1:N

            % initializes partial font size results
            widths_sz = [];

            set(h_txt,'fontname',fntnm{n});

            % loop over font sizes
            for sz = fntsz

                % build a string with C times the character
                str = repmat(letters(c),[1,nrep]);

                % get pixel dimensions of string
                [hndls,w,h] = getTextwrapDim(str,fntun,sz,fntnm{n},fntwt,...
                    hndls);
                w = round(w);
                h = round(h);

                % fit figure dimensions to text
                posfig = get(h_fig,'position');
                set(h_fig,'position',[posfig([1,2]),w,h]);

                % print text in figure
                set(h_txt,'fontsize',sz,'string',repSpecialChar(str),...
                    'position',[1,1,w,h]);

                % save figure to image
                print(h_fig,fname,'-dpng','-r0');

                % load, linearize and binarize image
                img = imread(fname);
                img = sum(img,3);
                iswhite = sum(img==3*255,1);
                isblack = (img~=255*sum(bg) & img~=3*255);
                img(isblack) = 1;
                img(~isblack) = 0;
                img = sum(img,1);
                img = ~~img(~iswhite);
                L = size(img,2);

                % get text limits
                for c1 = 1:L
                    if img(c1)~=0
                        break;
                    end
                end
                for c2 = L:-1:1
                    if img(c2)~=0
                        break;
                    end
                end
                if c1==L % no text (font size too small)
                    w0_first = minw0; % first space width
                    w0_last = minw0; % last space width

                else
                    w0_first = c1-1;
                    w0_last = L-c2;
                    if w0_first<minw0 % starting space too small
                        w0_first = minw0; % starting space width
                    end
                    if w0_last<minw0 % ending space too small
                        w0_last = minw0; % ending space width
                    end
                end

                w = (L-w0_first-w0_last)/nrep; % character + space width
                if w<minw
                    w = minw;
                end

                % store partial font size results
                widths_sz = cat(1,widths_sz,[w,h,(w0_first+w0_last)/2]);
            end

            % store partial font name results
            widths_nm = cat(4,widths_nm,widths_sz);
        end

        % store results
        results{3} = cat(3,results{3},widths_nm);
        
        % display progression
        if fix(100*c/C)>prgrss
            prgrss = fix(100*c/C);
            nbytes = dispProgress(['progression: ',num2str(prgrss),'%%\n'],...
                nbytes);
        end
    end
    
    dispProgress('progression: 100%%\n',nbytes);
    
    % close figures
    close(h_fig);
    close(hndls(1));
    
    % delete dummy file
    delete(fname);
    
catch err
    disp(cat(2,'ERROR: ',err.message));
    for i = 1:size(err.stack,1)
        disp(cat(2,'in ',err.stack(i,1).name,' line ',...
            num2str(err.stack(i,1).line)));
    end
    return
end


function [hndls,w,h] = getTextwrapDim(str,fntUn,fntSz,fntNm,fntWght,hndls)
% Returns text-styled uicontrol's width in pixel.

w = 0;
h = 0;
mg_y = 5/21; % top and bottom padding in relative units

% get pixel height of text control
switch fntUn
    case 'pixels'
        h = (1+mg_y)*fntSz;
    case 'points'
        h = (1+mg_y)*4*fntSz/3;
    otherwise
        disp('font units is not supported');
        return;
end

% get width of text control including extra space
[wstr,hndls] = getWidth(str,fntUn,fntSz,fntNm,fntWght,h,hndls);

% get width of empty text control including extra space
[wadd,hndls] = getWidth('',fntUn,fntSz,fntNm,fntWght,h,hndls);
wadd = wadd/2;

% get true width of text control
w = wstr-wadd+1;


function [w,hndls] = getWidth(str,fntUn,fntSz,fntNm,fntWght,h,hndls)

pixperchar = 3; % avergaged pixel width of a 9pt-sized character
incr = 1;
switch fntUn
    case 'pixels'
        pixperchar = pixperchar*fntSz/(32/3);
    case 'points'
        pixperchar = pixperchar*fntSz/9;
    case 'inches'
        pixperchar = pixperchar*fntSz/(1/8);
    case 'centimeters'
        pixperchar = pixperchar*fntSz/(2.54/8);
    case 'normalized'
        fntSzpix = fntSz*h;
        pixperchar = pixperchar*fntSzpix/(32/3);
end
if pixperchar<1
    pixperchar = 1;
end

% add dummy space to spaceless strings for textwrap function to work
txt = cat(2,str,' .');

min_w = pixperchar*length(txt);
postxt = [0 0 min_w h];
outstr = [' ';' '];

if isempty(hndls)
    h_fig = figure('visible','off');
    h_txt = uicontrol('style','text','parent',h_fig);
else
    h_fig = hndls(1);
    h_txt = hndls(2);
end

set(h_txt,'fontunits',fntUn,'fontsize',fntSz,'fontname',fntNm,'fontweight',...
    fntWght,'string',repSpecialChar(txt));

while numel(outstr)>1
    set(h_txt,'position',postxt);
    outstr = textwrap(h_txt,{txt});
    postxt(3) = postxt(3) + incr;
end

w = postxt(3);
hndls = [h_fig,h_txt];

% create uicontrol to verrify calculated dimensions:

% posfig = get(h_fig,'position');
% posfig(3:4) = 10*[w,h_txt];
% set(h_fig,'position',posfig);
% x = (posfig(3)+w)/2;
% y = (posfig(4)+h_txt)/2;
% uicontrol('style','text','parent',h_fig,'visible','on','fontunits',fntUn,...
%     'fontsize',fntSz,'fontweight',fntWght,'string',str,'position',...
%     [x,y,w,h_txt],'backgroundcolor',[0,1,0]);
% 
% delete(h_fig);

