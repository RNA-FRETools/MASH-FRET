function set_TP_asciiImpOpt(opt,h_fig)
% set_TP_asciiImpOpt(opt,h_fig)
%
% Set import options for ASCII trace files to proper values
%
% opt: structure containing import options as set in getDefault_TP (see p.asciiOpt)
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

nChan = opt.intImp{1}(7);
nL = opt.intImp{1}(8);

% open option window
openTrImpOpt(h.pushbutton_traceImpOpt,[],h_fig);

% collect interface parameters
h = guidata(h_fig);
q = h.trImpOpt;

% set coordinates import options
set(q.checkbox_inTTfile,'value',opt.coordImp{2}(1));
checkbox_inTTfile_Callback(q.checkbox_inTTfile,[],h_fig);

set(q.checkbox_extFile,'value',opt.coordImp{1}{1});
checkbox_extFile_Callback(q.checkbox_extFile,[],h_fig);
    
if opt.coordImp{2}(1)
    set(q.edit_rowCoord,'string',num2str(opt.coordImp{2}(2)));
    edit_rowCoord_Callback(q.edit_rowCoord,[],h_fig);
    
elseif opt.coordImp{1}{1}
    pushbutton_impCoordOpt_Callback(q.pushbutton_impCoordOpt,[],h_fig);
    set_VP_impIntgrOpt(opt.coordImp{1}{3},q.pushbutton_impCoordOpt,h_fig);
    
    set(q.edit_movWidth,'string',num2str(opt.coordImp{1}{4}));
    edit_movWidth_Callback(q.edit_movWidth,[],h_fig);
    
    pushbutton_impCoordFile_Callback(opt.coordImp{1}{2},[],h_fig)
end

% set video import options
set(q.checkbox_impMov,'value',opt.vidImp{1});
checkbox_impMov_Callback(q.checkbox_inTTfile,[],h_fig);
if opt.vidImp{1}
    pushbutton_impMovFile_Callback(opt.vidImp{2},[],h_fig);
end

% set intensity import options
set(q.edit_startRow,'string',num2str(opt.intImp{1}(1)));
edit_startRow_Callback(q.edit_startRow,[],h_fig);

set(q.edit_stopRow,'string',num2str(opt.intImp{1}(2)));
edit_stopRow_Callback(q.edit_stopRow,[],h_fig);

set(q.edit_startColI,'string',num2str(opt.intImp{1}(5)));
edit_startColI_Callback(q.edit_startColI,[],h_fig);

set(q.edit_stopColI,'string',num2str(opt.intImp{1}(6)));
edit_stopColI_Callback(q.edit_stopColI,[],h_fig);

set(q.checkbox_timeCol,'value',opt.intImp{1}(3));
checkbox_timeCol_Callback(q.checkbox_timeCol,[],h_fig);
if opt.intImp{1}(3)
    set(q.edit_timeCol,'string',num2str(opt.intImp{1}(4)));
    edit_timeCol_Callback(q.edit_timeCol,[],h_fig);
end

set(q.edit_nbChan,'string',num2str(nChan));
edit_nbChan_Callback(q.edit_nbChan,[],h_fig);

set(q.edit_nbExc,'string',num2str(nL));
edit_nbExc_Callback(q.edit_nbExc,[],h_fig);

for l = 1:nL
    set(q.popupmenu_exc,'value',l);
    popupmenu_exc_Callback(q.popupmenu_exc,[],h_fig);

    set(q.edit_wl,'string',num2str(opt.intImp{2}(l)));
    edit_wl_Callback(q.edit_wl,[],h_fig);
end

% set correction factors import options
set(q.checkbox_impGam,'value',opt.factImp{1});
checkbox_impGam_Callback(q.checkbox_impGam,[],h_fig);
if opt.factImp{1}
    pushbutton_impGamFile_Callback(opt.factImp([2,3]),[],h_fig);
end

set(q.checkbox_impBet,'value',opt.factImp{4});
checkbox_impBet_Callback(q.checkbox_impBet,[],h_fig);
if opt.factImp{4}
    pushbutton_impBetFile_Callback(opt.factImp([5,6]),[],h_fig);
end

% set state trajectories import options
set(q.checkbox_dFRET,'value',opt.intImp{1}(9));
checkbox_dFRET_Callback(q.checkbox_dFRET,[],h_fig);
if opt.intImp{1}(9)
    set(q.edit_thcol,'string',num2str(opt.intImp{1}(10)));
    edit_thcol_Callback(q.edit_thcol,[],h_fig);
end

% save and close option window
pushbutton_trImpOpt_ok_Callback(q.pushbutton_trImpOpt_ok,[],h_fig);
