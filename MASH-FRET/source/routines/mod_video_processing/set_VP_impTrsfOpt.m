function set_VP_impTrsfOpt(rw,prm_ref,prm,h_fig)
% set_VP_impTrsfOpt(p,h_fig)
%
% Set coordinates transformation import options to proper values and update interface parameters
%
% rw: (1) if reference coordinates are organized row-wise, (0) for column-wise
% prm_ref: {1-by-3} reference coordinates import settings with:
%  prm_ref{1}: [1-by-2] reference image x- and y-dimensions (in pixels)
%  for row-wise organization:
%   prm_ref{2}: [1-by-2] column indexes in file where x- and y-coordinates are written
%   prm_ref{3}: [nChan-by-3] first line index, line inetrval and last line index (0 for end-of-file) used to read channel-specific coordinates
%  for column-wise organization:
%   prm_ref{2}: number of header line in file
%   prm_ref{3}: [nChan-by-2] column indexes in file where channel-specific x- and y-coordinates are written
% prm: [1-by-2] spots coordinates import settings
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

% open import option window
pushbutton_trOpt_Callback(h.pushbutton_trOpt,[],h_fig);

% collect modified interface parameters
h = guidata(h_fig);
q = h.trsfOpt;

% set reference coordinates import options
if rw
    radiobutton_rw_Callback(q.radiobutton_rw,[],h_fig);
    
    set(q.edit_rColX,'string',num2str(prm_ref{2}(1)));
    set(q.edit_rColY,'string',num2str(prm_ref{2}(2)));
    
    for c = 1:size(prm_ref{3},1)
        set(q.edit_start(c),'string',num2str(prm_ref{3}(c,1)));
        set(q.edit_iv(c),'string',num2str(prm_ref{3}(c,2)));
        set(q.edit_stop(c),'string',num2str(prm_ref{3}(c,3)));
    end
else
    radiobutton_cw_Callback(q.radiobutton_cw,[],h_fig);
    
    set(q.edit_nHead,'string',num2str(prm_ref{2}));
    
    for c = 1:size(prm_ref{3},1)
        set(q.edit_cColX(c),'string',num2str(prm_ref{3}(c,1)));
        set(q.edit_cColY(c),'string',num2str(prm_ref{3}(c,2)));
    end
end

% set spots coordinates import options
set(q.edit_molXcol,'string',num2str(prm(1)));
set(q.edit_molYcol,'string',num2str(prm(2)));

% save options and close window
pushbutton_trsfOpt_ok_Callback(q.pushbutton_trsfOpt_ok,[],h_fig);
