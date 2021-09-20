function str_prm = getStrPrm(s, m, incl, h_fig)

% Last update by MH, 23.12.2020: add vbFRET-2D
% update by MH, 24.4.2019: adapt code to multiple molecule tags
% update by MH, 3.4.2019: (1) fix error occuring when exporting ASCII: cross-talks section is adapted to new parameter formats (see project/setDefPrm_traces.m), (2) add new input argument "incl" to correct exported molecule index (m_i and N_i), (3) correct photobleaching method, (4) write to file new parameters: date of export, MASH version at project creation to file (in addition to version at last saving) and molecule tag, (5) compact dwell time analysis section, (6) improve file aesthetic and efficacity by replacing channel indexes by labels, removing html tags in data labels taken from popupmenus, replace sprintf(...) by num2str(...) to get pretty number formats, add categories "PROJECT", "VIDEO PROCESSING", "EXPERIMENT SETTINGS" and "MOLECULE"


%% collect parameters

% collect project parameters
exc = s.excitations;
nExc = numel(exc);
nChan = s.nb_channel;
chanExc = s.chanExc;
labels = s.labels;
tag = s.molTag;
tagName = s.molTagNames;
exptime = s.frame_rate;
nPix = s.pix_intgr(2);
FRET = s.FRET; 
S = s.S;
projprm = s.exp_parameters;
coord = s.coord;

if ~isempty(s.proj_file)
    proj_file = strrep(s.proj_file, '\', '\\');
else
    proj_file = 'empty';
end

if ~isempty(s.movie_file)
    movie_file = strrep(s.movie_file, '\', '\\');
else
    movie_file = 'empty';
end

if ~isempty(s.coord_file)
    coord_file = strrep(s.coord_file, '\', '\\');
else
    coord_file = 'empty';
end

% get dimensions
nFRET = size(FRET,1);
nS = size(S,1);
nMol = size(coord,1);
nMol_i = numel(find(incl));

% get molecule index in exported set
m_i = find(find(incl) == m);

% collect processing parameters
perSec = s.fix{2}(4); % intensity units per second
perPix = s.fix{2}(5); % intensity units per pixel
inSec = s.fix{2}(7); % x-axis in second
prm_bg = s.prm{m}{3};
prm_cross = s.fix{4};
prm_fact = s.prm{m}{6};
prm_den = s.prm{m}{1};
prm_bleach = s.prm{m}{2};
prm_dta = s.prm{m}{4};

% collect infos from GUI
h = guidata(h_fig);
str_meth_bg = get(h.popupmenu_trBgCorr, 'String');
str_meth_den = get(h.popupmenu_denoising, 'String');
str_meth_pb = get(h.popupmenu_debleachtype, 'String');
str_meth_dta = get(h.popupmenu_TP_states_method, 'String');
str_chan_pb = removeHtml(get(h.popupmenu_bleachChan, 'String'));
str_chan_dta = removeHtml(getStrPop('DTA_chan', ...
    {labels FRET S exc s.colours}));

% current MASH version
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
vers = figname(b:end);


%% build individual parameter strings

% excitation wavelength
str_wl = [];
for l = 1:nExc
    str_wl = cat(2,str_wl,'\t',num2str(exc(l)),'nm\n');
end

% channel excitations
str_chanExc = '';
for c = 1:nChan
    if ~chanExc(c)
        str_chanExc = cat(2,str_chanExc, '\t', labels{c}, '(channel ', ...
            num2str(c), ') not defined\n');
    else
        str_chanExc = cat(2,str_chanExc, '\t', labels{c}, '(channel ', ...
            num2str(c), ') at ', num2str(chanExc(c)), 'nm\n');
    end
end

% experimental parameters
str_exp_prm = [];
for i = 1:size(projprm,1)
    prm_add = [];
    if ~isempty(projprm{i,2})
        prm = strrep(projprm{i,1}, '%', '%%');
        prm_add = cat(2,prm_add, '\t', prm, ':');
        if isnumeric(projprm{i,2})
            prm = num2str(projprm{i,2});
        else
            prm = projprm{i,2};
        end
        prm_add = cat(2,prm_add, prm);
        if ~isempty(projprm{i,3})
            prm = strrep(projprm{i,3}, '%', '%%');
            prm_add = cat(2,prm_add, prm);
        end
        str_exp_prm = cat(2,str_exp_prm, prm_add, '\n');
    end
end

% coordinates
if ~isempty(coord)
    str_coord = '';
    for c = 1:nChan
        str_coord = cat(2,str_coord,'\n\tin ',labels{c},' channel: ', ...
            num2str(coord(m,2*c-1)),',',num2str(coord(m,2*c)));
    end
else
    str_coord = 'not available';
end

% intensity units
str_units = 'counts';
if perSec
    str_units = cat(2,str_units, ' per second');
end
if perPix
    str_units = cat(2,str_units, ' per pixel');
end

% FRET
if nFRET > 0
    str_fret = '';
    for i = 1:nFRET
        str_fret = cat(2,str_fret,'\n\tfrom ',labels{FRET(i,1)},' to ',...
            labels{FRET(i,2)});
    end
    str_fret = cat(2,str_fret,'\n');
else
    str_fret = 'none\n';
end

% stoichiometry
if nS > 0
    str_s = '';
    for i = 1:nS
        str_s = cat(2,str_s,'\n\tfor pair ',labels{S(i,1)},'-',...
            labels{S(i,2)});
    end
    str_s = cat(2,str_s,'\n');
else
    str_s = 'none\n';
end

% molecule tags
nTag = sum(tag(m,:));
if nTag==0
    str_tags = 'none';
else
    str_tags = '';
    for t = 1:numel(tagName)
        if tag(m,t)
            str_tags = cat(2,str_tags,' ',tagName{t},',');
        end
    end
    str_tags(end) = [];
end

%% background corrections
str_bg = '';
for l = 1:nExc
    for c = 1:nChan
        str_bg = cat(2,str_bg,'\t',labels{c},' at ',num2str(exc(l)),...
            'nm: ');
        if ~prm_bg{1}(l,c)
            str_bg = cat(2,str_bg,'none\n');
        else
            
            bgInt = prm_bg{3}{l,c}(prm_bg{2}(l,c),3);
            if perSec
                bgInt = bgInt/exptime;
            end
            if perPix
                bgInt = bgInt/nPix;
            end
            
            str_bg = cat(2,str_bg,', BG intensity: ',num2str(bgInt), ...
                ' (method: "',str_meth_bg{prm_bg{2}(l,c)},'"');
            
            switch prm_bg{2}(l,c)
                case 1 % manual
                    str_bg = cat(2,str_bg,')\n');
                    
                case 2 % darkest
                    str_bg = cat(2,str_bg,', sub-image dimensions: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),2)),' px',...
                        ')\n');
                    
                case 3 % mean
                    str_bg = cat(2,str_bg,', tolerance cutoff: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),1)),...
                        ', sub-image dimensions: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),2)),' px',...
                        ')\n');
                    
                case 4 % most frequent
                    str_bg = cat(2,str_bg,', number of histogram bin: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),1)),...
                        ', sub-image dimensions: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),2)),' px',...
                        ')\n');
                    
                case 5 % histothresh
                    str_bg = cat(2,str_bg,', cumulative probability ',...
                        'threshold: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),1)),...
                        ', sub-image dimensions: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),2)),' px',...
                        ')\n');
                    
                case 6 % dark trace
                    str_bg = cat(2,str_bg,', running average window ',...
                        'size: ',num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),1)),...
                        ', sub-image dimensions: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),2)),' px',...
                        ', dark coordinates: (',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),4)),',',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),5)),')',...
                        ')\n');
                    
                case 7 % median
                    str_bg = cat(2,str_bg,', calculation method: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),1)),...
                        ', sub-image dimensions: ',...
                        num2str(prm_bg{3}{l,c}(prm_bg{2}(l,c),2)),' px',...
                        ')\n');
            end
        end
    end
end

%% cross-talks
str_fact = '';
if nChan>1
    for c = 1:nChan
        str_fact = cat(2,str_fact,'\tbleedthrough coefficients of emitter ',...
                labels{c},': ');
        n = 0;
        for c_i = 1:nChan
            if c_i ~= c
                n = n+1;
                str_fact = cat(2,str_fact,'Bt=',num2str(prm_cross{1}(c,n)),...
                    ' in ',labels{c_i});
                if n<nChan-1
                    str_fact = cat(2,str_fact,', ');
                else
                    str_fact = cat(2,str_fact,'\n');
                end
            end
        end
    end
else
    str_fact = cat(2,str_fact,'\tno bleedthrough possible\n');
end
if nExc>1
    for c = 1:nChan
        
        str_fact = cat(2,str_fact,'\tdirect excitation coefficients of',...
            ' emitter ',labels{c},': ');
        
        l_0 = find(exc==chanExc(c));
        if isempty(l_0)
            str_fact = cat(2,str_fact,'not possible (emitter-specific ',...
                'illumination not defined or used in experiment)\n');
            continue;
        end
        l_0 = l_0(1);
        
        n = 0;
        for l = 1:nExc
            if l ~= l_0
                n = n+1;
                str_fact = cat(2,str_fact,'DE=',num2str(prm_cross{2}(n,c)),...
                    ' at ',num2str(exc(l)),'nm');
                if n<nExc-1
                    str_fact = cat(2,str_fact,', ');
                else
                    str_fact = cat(2,str_fact,'\n');
                end
            end
        end
    end
else
    str_fact = cat(2,str_fact,'\tno direct excitation possible\n');
end


%% factor corrections
if nFRET>0
    for i = 1:nFRET
        str_fact = cat(2,str_fact,'\tcorrection factors for FRET_',...
            labels{FRET(i,1)},'>',labels{FRET(i,2)},': gamma=',...
            num2str(prm_fact{1}(1,i)),', beta=',num2str(prm_fact{1}(2,i)),...
            '\n');
    end
else
    str_fact = cat(2,str_fact,'\tno gamma or beta correction possible\n');
end

%% denoising
if prm_den{1}(2)
    str_den = cat(2,'\n\tmethod: "', str_meth_den{prm_den{1}(1)},'"');
    switch prm_den{1}(1)
        case 1 % sliding averaging
            str_den = cat(2,str_den,', running average window size: ',...
                num2str(prm_den{2}(prm_den{1}(1),1)),'\n');
        case 2 % Haran filter
            str_den = cat(2,str_den,', exponent of predictor weight: ', ...
                num2str(prm_den{2}(prm_den{1}(1),1)), ...
                ', running average window (RAW) size: ', ...
                num2str(prm_den{2}(prm_den{1}(1),2)), ...
                ', factor (predictor RAW sizes): ', ...
                num2str(prm_den{2}(prm_den{1}(1),3)),'\n');
        case 3 % Wavelet analysis
            switch prm_den{2}(prm_den{1}(1),1)
                case 1
                    str_den = cat(2,str_den,', firm shrink');
                case 2
                    str_den = cat(2,str_den,', hard shrink');
                case 3
                    str_den = cat(2,str_den,', soft shrink');
            end
            switch prm_den{2}(prm_den{1}(1),2)
                case 1
                    str_den = cat(2,str_den,', local time');
                case 2
                    str_den = cat(2,str_den,', universal time');
            end
            switch prm_den{2}(prm_den{1}(1),3)
                case 1
                    str_den = cat(2,str_den,', cycle spin on\n');
                case 2
                    str_den = cat(2,str_den,', no cycle spin\n');
            end
    end
else
    str_den = 'none\n';
end

%% photobleaching
if prm_bleach{1}(1)
    if inSec
        str_bleach = cat(2,'\n\tcutoff time: ',...
            num2str(prm_bleach{1}(5)*exptime),' seconds');
    else
        str_bleach = cat(2,'\n\tcutoff frame: ',num2str(prm_bleach{1}(5)));
    end
    str_bleach = cat(2,str_bleach,' (method: "', ...
        str_meth_pb{prm_bleach{1}(2)},'"');
    
    if prm_bleach{1}(2) == 2
        str_bleach = cat(2,str_bleach,', processed data: ', ...
            str_chan_pb{prm_bleach{1}(3)}, ...
            ', threshold at: ', ...
            num2str(prm_bleach{2}(prm_bleach{1}(3),1)), ...
            ', extra frames to cut: ', ...
            num2str(prm_bleach{2}(prm_bleach{1}(3),2)),...
            ', min. cutoff frame: ', ...
            num2str(prm_bleach{2}(prm_bleach{1}(3),3)));
    end
    
    str_bleach = cat(2,str_bleach,')\n');
    
else
    str_bleach = 'none\n';
end


%% dwell-time analysis
if prm_dta{1}(2)==1 % to bottom only
    ids = 1:(nFRET+nS);
    str_dta = cat(2,'method "', str_meth_dta{prm_dta{1}(1)},...
        '" applied to bottom traces');
    
elseif prm_dta{1}(2)==2 % to top and bottom
    ids = 1:(nChan*nExc+nFRET+nS);
    str_dta = cat(2,'method "', str_meth_dta{prm_dta{1}(1)},...
        '" applied to top and bottom traces');
    
elseif prm_dta{1}(2)==0 % to top only, deduct bottom
    ids = [nFRET+nS+1:nChan*nExc+nFRET+nS,1:nFRET+nS];
    str_dta = cat(2,'method "', str_meth_dta{prm_dta{1}(1)},'" applied to',...
        ' top traces and use shared transitions in bottom traces');
end

if prm_dta{1}(1)==4 % One state
    ids = [];
    str_dta = cat(2,str_dta,'\n');
else
    str_dta = cat(2,str_dta,' with parameters:\n');
end

for i = ids
    switch prm_dta{1}(1)
        case 1 % thresholding
            str_dta = cat(2,str_dta,'\tfor ',str_chan_dta{i},':');
            if prm_dta{1}(2) || (prm_dta{1}(2)==0 && i>nFRET+nS)
                str_dta = cat(2,str_dta,' max. number of states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),1,i)),...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)),...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)),...
                    ', threshold parameters [state low high]:');

                for state = 1:prm_dta{2}(prm_dta{1}(1),1,i)
                    str_dta = cat(2,str_dta,' [',...
                        num2str(prm_dta{4}(1,state,i)),' ',...
                        num2str(prm_dta{4}(2,state,i)),' ',...
                        num2str(prm_dta{4}(3,state,i)),']');
                end
            else
                str_dta = cat(2,str_dta,...
                    ' tolerance window size: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),4,i)), ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
            end
            
            str_dta = cat(2,str_dta,'\n');

        case 2 % vbFRET-1D
            str_dta = cat(2,str_dta,'\tfor ',str_chan_dta{i},':');
            if prm_dta{1}(2) || (prm_dta{1}(2)==0 && i>nFRET+nS)
                str_dta = cat(2,str_dta, ...
                    ' min. number of states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),1,i)), ...
                    ', max. number of states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),2,i)), ...
                    ', max. iteration number: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),3,i)), ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
            else
                str_dta = cat(2,str_dta,...
                    ' tolerance window size: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),4,i)), ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
            end
            
            str_dta = cat(2,str_dta,'\n');

        case 3 % vbFRET-2D
            str_dta = cat(2,str_dta,'\tfor ',str_chan_dta{i},':');
            if prm_dta{1}(2) || (prm_dta{1}(2)==0 && i>nFRET+nS)
                str_dta = cat(2,str_dta, ...
                    ' min. number of states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),1,i)), ...
                    ', max. number of states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),2,i)), ...
                    ', max. iteration number: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),3,i)), ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
            else
                str_dta = cat(2,str_dta,...
                    ' tolerance window size: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),4,i)), ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
            end
            
            str_dta = cat(2,str_dta,'\n');

        case 5 % CPA
            str_dta = cat(2,str_dta,'\tfor ',str_chan_dta{i},':');
            if prm_dta{1}(2) || (prm_dta{1}(2)==0 && i>nFRET+nS)
                switch prm_dta{2}(prm_dta{1}(1),3,i)
                    case 1
                        str = '"maximum"';
                    case 2
                        str = '"MSE"';
                end
                str_dta = cat(2,str_dta,' number of bootstrap samples: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),1,i)), ...
                    ', significance level: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),2,i)/100), ...
                    ', identify changes by: ',str, ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
            else
                str_dta = cat(2,str_dta,...
                    ' tolerance window size: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),4,i)), ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
            end
            
            str_dta = cat(2,str_dta,'\n');

        case 6 % STaSI
            str_dta = cat(2,str_dta,'\tfor ',str_chan_dta{i},':');
            if prm_dta{1}(2) || (prm_dta{1}(2)==0 && i>nFRET+nS)
                str_dta = cat(2,str_dta,...
                    ' max. number of states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),1,i)), ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
                
            else
                str_dta = cat(2,str_dta,...
                    ' tolerance window size: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),4,i)), ...
                    ', number of refinment cycles: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),5,i)), ...
                    ', state binning: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),6,i)),...
                    ', remove blurr states: ', ...
                    num2str(prm_dta{2}(prm_dta{1}(1),7,i)));
            end
            
            str_dta = cat(2,str_dta,'\n');
    end
end


%% build final parameter string

str_prm = cat(2,'PROJECT\n',...
    '> project file: ',proj_file,'\n', ...
    '> project created with MASH-FRET version: ',s.MASH_version,'\n', ... 
    '> project creation: ',s.date_creation,'\n', ...
    '> last project modification: ',s.date_last_modif,'\n', ...
    '> file exported with MASH-FRET version: ',vers,'\n\n', ... 
    'VIDEO PROCESSING\n',...
    '> movie file: ',movie_file,'\n', ...
    '> frame rate: ',num2str(1/s.frame_rate),' s-1 \n', ...
    '> pixel integration area: ',num2str(s.pix_intgr(1)),' x ',num2str(s.pix_intgr(1)),'\n', ... 
    '> number of brightest pixels integrated: ',num2str(s.pix_intgr(2)),'\n', ...
    '> coordinates file: ',coord_file,'\n\n', ... 
    'EXPERIMENT SETTINGS\n',...
    '> alternated lasers used in experiment (chronological order):\n',str_wl, ...
    '> emitter-specific detection channels and illuminations:\n', str_chanExc, ...
    '> experimental parameters:\n',str_exp_prm, ...
    '> FRET calculations:',str_fret, ...
    '> stoichiometry calculations:',str_s,'\n', ...
    'MOLECULE\n',...
    '> molecule index: ',num2str(m),' on ',num2str(nMol),' (',num2str(m_i),' on ',num2str(nMol_i),' exported)\n', ...
    '> molecule tags:',str_tags,'\n',...
    '> molecule coordinates: ',str_coord,'\n', ...
    '> intensity units: ',str_units,'\n', ...
    '> background correction: \n',str_bg, ...
    '> factor corrections: \n',str_fact, ...
    '> denoising: ',str_den, ...
    '> photobleaching correction: ',str_bleach, ...
    '> discretisation: ',str_dta);

