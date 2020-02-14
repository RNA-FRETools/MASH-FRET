function ud_trImpOpt(h_fig)
% ud_trImpOpt(h_fig)
%
% Set ASCII import option figure to proper values.
% Import options are recovered from options window's guidata (type "help buildWinTrOpt" for more information about options structure)
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
q = h.trImpOpt;

% collect import otpions
opt = guidata(h.figure_trImpOpt);

% enable all controls
setProp(h.figure_trImpOpt,'enable','on');
setProp(h.figure_trImpOpt,'visible','on');

% reset background color of all edit fields
set([q.edit_rowCoord,q.edit_movWidth,q.edit_fnameCoord,q.edit_fnameMov,...
    q.edit_timeCol,q.edit_wl,q.edit_nbExc,q.edit_nbChan,q.edit_startColI,...
    q.edit_stopColI,q.edit_startRow,q.edit_stopRow,q.edit_fnameGam,...
    q.edit_fnameBet,q.edit_thcol],'backgroundcolor',[1,1,1]);


% set panel Molecule coordinates
set(q.checkbox_inTTfile,'Value',opt{4}(1));
set(q.checkbox_extFile,'Value',opt{3}{1});

if opt{4}(1)
    set(q.edit_rowCoord,'String',num2str(opt{4}(2)));
else
    set([q.edit_rowCoord,q.text_rowCoord],'enable','off');
    set(q.edit_rowCoord,'string','');
end
if opt{3}{1}
    set(q.edit_movWidth,'String',num2str(opt{3}{4}));
    if ~isempty(opt{3}{2})
        [o,fname_coord,fext] = fileparts(opt{3}{2});
        fname_coord = [fname_coord fext];
        set(q.edit_fnameCoord,'string',fname_coord);
    else
        set(q.edit_fnameCoord,'string','','enable','off');
    end
else
    set([q.text_movWidth,q.edit_movWidth,q.pushbutton_impCoordFile,...
        q.edit_fnameCoord,q.pushbutton_impCoordOpt],'enable','off');
    set([q.edit_movWidth,q.edit_fnameCoord],'string','');
end


% set panel Single molecule video
set(q.checkbox_impMov,'Value',opt{2}{1});
if ~opt{2}{1}
    set([q.pushbutton_impMovFile,q.edit_fnameMov],'enable','off');
    set(q.edit_fnameMov,'string','');
else
    if ~isempty(opt{2}{2})
        [o,fname_mov,fext] = fileparts(opt{2}{2});
        fname_mov = [fname_mov fext];
        set(q.edit_fnameMov,'String',fname_mov);
    else
        set(q.edit_fnameMov,'String','','enable','off');
    end
end


% set panel Intensity-time traces
if ~opt{1}{1}(3)
    set([q.text_timeCol,q.edit_timeCol],'enable','off');
    set(q.edit_timeCol,'string','');
else
    set(q.edit_timeCol,'String',num2str(opt{1}{1}(4)));
end
str_pop = {};
for i = 1:opt{1}{1}(8)
    if i > numel(opt{1}{2})
        opt{1}{2}(i) = round(opt{1}{2}(1)*(1 + 0.2*(i-1)));
    end
    str_pop = cat(2,str_pop,['exc. ' num2str(i)]);
end
l = get(q.popupmenu_exc,'value');
if l>opt{1}{1}(8)
    l = opt{1}{1}(8);
end
set(q.popupmenu_exc,'string',str_pop,'value',l);
set(q.edit_wl,'String',num2str(opt{1}{2}(l)));
set(q.edit_nbExc,'String',num2str(opt{1}{1}(8)));
set(q.edit_nbChan,'String',num2str(opt{1}{1}(7)));
set(q.checkbox_timeCol,'Value',opt{1}{1}(3));
set(q.edit_startColI,'String',num2str(opt{1}{1}(5)));
set(q.edit_stopColI,'String',num2str(opt{1}{1}(6)));
set(q.edit_startRow,'String',num2str(opt{1}{1}(1)));
set(q.edit_stopRow,'String',num2str(opt{1}{1}(2)));


% set panel Correction factors
set(q.checkbox_impBet,'Value',opt{6}{4});
set(q.checkbox_impGam,'Value',opt{6}{1});
if ~opt{6}{1}
    set([q.pushbutton_impGamFile,q.edit_fnameGam],'enable','off');
    set(q.edit_fnameGam,'string','');
else
    str_gamfile = '';
    if ~isempty(opt{6}{3})
        fname_gam = opt{6}{3};
        for i = 1:numel(fname_gam)
            str_gamfile = cat(2,str_gamfile,fname_gam{i},'; ');
        end
        set(q.edit_fnameGam,'String',str_gamfile(1:end-2));
    else
        set(q.edit_fnameGam,'String','','enable','off');
    end
end
if ~opt{6}{4}
    set([q.pushbutton_impBetFile,q.edit_fnameBet],'Enable','off');
    set(q.edit_fnameBet,'string','');
else
    str_betfile = '';
    if ~isempty(opt{6}{6})
        fname_bet = opt{6}{6};
        for i = 1:numel(fname_bet)
            str_betfile = cat(2,str_betfile,fname_bet{i},'; ');
        end
        set(q.edit_fnameBet,'String',str_betfile(1:end-2));
    else
        set(q.edit_fnameBet,'String','','enable','off');
    end
end

% set panel State trajectories
set(q.checkbox_dFRET ,'Value',opt{1}{1}(9));
if ~opt{1}{1}(9)
    set([q.text_every,q.edit_thcol,q.text_thcol],'enable','off');
    set(q.edit_thcol,'string','');
else
    set(q.edit_thcol,'String',num2str(opt{1}{1}(10)));
end

