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

% import video and set defaults
setDefault_VP(h_fig,p)

disp(cat(2,prefix,'test intensity integration for different channels...'));
for nChan = 1:3
    % set number of channels
    set(h.edit_nChannel,'string',num2str(nChan));
    edit_nChannel_Callback(h.edit_nChannel,[],h_fig);
    
    % set import options
    set_VP_impIntgrOpt(p.coord_impOpt,h_fig);
    
    % import coordinates
    disp(cat(2,prefix,'>> import coordinates from ',p.coord_file{nChan},...
        '...'));
    pushbutton_TTgen_loadCoord_Callback({p.annexpth,p.coord_file{nChan}},...
        [],h_fig);
    
    % set file options
    openItgFileOpt(h.pushbutton_TTgen_fileOpt,[],h_fig);
    set_VP_expOpt(expopt,h_fig);

    % save to .mash file
    pushbutton_itgFileOpt_ok_Callback({p.dumdir,p.exp_traceFile{nChan}},[],...
        h_fig);
end

% test export options one-by-one
disp(cat(2,prefix,'test export options...'));
set(h.edit_nChannel,'string',num2str(2));
edit_nChannel_Callback(h.edit_nChannel,[],h_fig);
    
disp(cat(2,prefix,'>> import coordinates from ',p.coord_file{2}));
pushbutton_TTgen_loadCoord_Callback({p.annexpth,p.coord_file{2}},[],h_fig);
for n = 1:size(expopt,2)
    disp(cat(2,prefix,'>> export ',p.expFmt{n},'file...'));
    % set export otpions
    openItgFileOpt(h.pushbutton_TTgen_fileOpt,[],h_fig);
    opt = expopt;
    opt(n) = true;
    set_VP_expOpt(opt,h_fig);
    
    % save file
    pushbutton_itgFileOpt_ok_Callback({p.dumdir,p.exp_traceFile{2}},[],...
        h_fig);
end

