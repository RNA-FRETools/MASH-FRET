function routinetest_VP_traceExport(h_fig,p,prefix)
% routinetest_VP_traceExport(h_fig,p,prefix)
%
% Tests trace export for different file formats 
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
expopt = false(1,7);

% test export options one-by-one
disp(cat(2,prefix,'test export options...'));

% set defaults
setDefault_VP(h_fig,p,prefix)
    
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
