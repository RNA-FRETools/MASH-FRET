function routinetest_VP_experimentSettings(h_fig,p,prefix)
% routinetest_VP_experimentSettings(h_fig,p,prefix)
%
% Tests experiment settings and project options
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% collect interface parameters
h = guidata(h_fig);

% set defaults
setDefault_VP(h_fig,p);

disp(cat(2,prefix,'test experiment settings for different number of ',...
    'channels and lasers...'));
for nChan = 1:p.nChan_max
    % set number of channels
    set(h.edit_nChannel,'string',num2str(nChan));
    edit_nChannel_Callback(h.edit_nChannel,[],h_fig);
    
    for nL = 1:p.nL_max
        disp(cat(2,prefix,...
            sprintf('>> set %i channels and %i lasers...',nChan,nL)));
        % set lasers
        set_VP_lasers(nL,p.wl(1:nL),h_fig);
    
        % set project options
        set_VP_projOpt(p.projOpt{nL,nChan},p.wl,h_fig);
    end
end

