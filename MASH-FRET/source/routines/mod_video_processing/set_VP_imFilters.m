function set_VP_imFilters(corr,prm,bgall,h_fig)
% set_VP_imFilters(corr,prm,bgall,h_fig)
%
% Configure imae filters and update interface parameters
%
% corr: [1-by-nCorr] indexes of image filters in menu
% prm: filter parameters for each method
% bgall: (1) to filter all video frames, (0) to filter the current frame only
% h_fig: handle to main figure

% get interface parameters
h = guidata(h_fig);

set(h.checkbox_bgCorrAll,'value',bgall);
checkbox_bgCorrAll_Callback(h.checkbox_bgCorrAll,[],h_fig);

% remove existing filters
nCorr = numel(get(h.listbox_bgCorr,'string'));
n = nCorr;
while n>0
    set(h.listbox_bgCorr,'value',n);
    pushbutton_remBgCorr_Callback(h.pushbutton_remBgCorr,[],h_fig);
end

% add filters
for n = 1:size(corr,2);
    set(h.popupmenu_bgCorr,'value',corr(n));
    popupmenu_bgCorr_Callback(h.popupmenu_bgCorr,[],h_fig);
    
    if corr(n)==17 % background image
        pushbutton_addBgCorr_Callback({[p.annexpth,filesep,p.bgimg]},[],...
            h_fig);
    else
        for c = 1:p.nChan
            set(h.popupmenu_bgChanel,'value',c);
            popupmenu_bgChanel_Callback(h.popupmenu_bgChanel,[],h_fig);

            set(h.edit_bgParam_01,'string',num2str(prm(meth,1)));
            edit_bgParam_01_Callback(h.edit_bgParam_01,[],h_fig);

            set(h.edit_bgParam_02,'string',num2str(prm(meth,2)));
            edit_bgParam_02_Callback(h.edit_bgParam_02,[],h_fig);
        end
        pushbutton_addBgCorr_Callback(h.pushbutton_addBgCorr,[],h_fig);
    end
end
