function routinetest_VP_intensityIntegration(h_fig,p,prefix)
% routinetest_VP_intensityIntegration(h_fig,p,prefix)
%
% Tests trace building and export for different file formats and various combinations of channels and lasers
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
expopt = false(1,7);

% collect interface parameters
h = guidata(h_fig);

% set defaults
setDefault_VP(h_fig,p)

disp(cat(2,prefix,'test intensity integration for different number of ',...
    'channels and lasers...'));
for nChan = 1:p.nChan_max
    % set number of channels
    set(h.edit_nChannel,'string',num2str(nChan));
    edit_nChannel_Callback(h.edit_nChannel,[],h_fig);
    
    % set import options
    impOpt = {reshape(1:(2*nChan),[2,nChan])',1};
    set_VP_impIntgrOpt(impOpt,h.pushbutton_TTgen_loadOpt,h_fig);
    
    % import coordinates
    disp(cat(2,prefix,'>> import coordinates from ',p.coord_file{nChan},...
        '...'));
    pushbutton_TTgen_loadCoord_Callback({p.annexpth,p.coord_file{nChan}},...
        [],h_fig);
    
    for nL = 1:p.nL_max
        % set lasers
        set_VP_lasers(nL,p.wl(1:nL),h_fig);
    
        % set project options
        set_VP_projOpt(p.projOpt{nL,nChan},p.wl,h.pushbutton_chanOpt,h_fig);

        % set file options
        set_VP_expOpt(expopt,h_fig);

        % save to .mash file
        pushbutton_itgFileOpt_ok_Callback({p.dumpdir,...
            p.exp_traceFile{nL,nChan}},[],h_fig);
    end
end

% test export options one-by-one
disp(cat(2,prefix,'test export options...'));

% set defaults
setDefault_VP(h_fig,p)
    
disp(cat(2,prefix,'>> import coordinates from ',p.coord_file{p.nChan}));
pushbutton_TTgen_loadCoord_Callback({p.annexpth,p.coord_file{p.nChan}},[],...
    h_fig);
for n = 1:size(expopt,2)
    disp(cat(2,prefix,'>> export ',p.expFmt{n},'file...'));
    % set export otpions
    opt = expopt;
    opt(n) = true;
    set_VP_expOpt(opt,h_fig);
    
    % save file
    pushbutton_itgFileOpt_ok_Callback(...
        {p.dumpdir,p.exp_traceFile{p.nL,p.nChan}},[],h_fig);
end

