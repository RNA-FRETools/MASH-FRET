function routinetest_TP_fileExport(h_fig,p,prefix)
% routinetest_TP_fileExport(h_fig,p,prefix)
%
% Tests ASCII file export
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)


% multi- and single-channel video-based mash files
vid_type = {'multi-channel', 'single-channel'};

[~,name,ext] = fileparts(p.mash_files{p.nL,p.nChan});
mash_files = {p.mash_files{p.nL,p.nChan},[name,'_sgl',ext]};
mash_dir = {name,[name,'_sgl']};

[~,name,ext] = fileparts(p.exp_figpreview);
fig_files = {p.exp_figpreview,[name,'_sgl',ext]};

for f = 1:numel(mash_files)
    
    disp(cat(2,prefix,'test ',vid_type{f},' video-based project...'));
    
    % open default project
    disp(cat(2,prefix,'>> import file ',mash_files{f}));
    pushbutton_openProj_Callback({[p.annexpth,mash_dir{f}],mash_files{f}},...
        [],h_fig);

    % set default parameters
    setDefault_TP(h_fig,p);

    disp(cat(2,prefix,'>> test all export...'));
    pushbutton_expTraces_Callback({false},[],h_fig);

    % get interface parameters
    h = guidata(h_fig);
    q = h.optExpTr;

    nFigFmt = numel(get(q.popupmenu_figFmt,'string'));
    opt = p.expOpt;
    opt.traces(1) = true;
    opt.hist(1) = true;
    opt.dt(1) = true;
    opt.fig{1}(1) = true;
    set_TP_asciiExpOpt(opt,h_fig);
    pushbutton_next_Callback({p.dumpdir,mash_files{f}},[],h_fig);

    % test trace export to single files/one file
    disp(cat(2,prefix,'>> test trace export options...'));
    opt = p.expOpt;
    opt.traces(1) = true;
    opt.traces(2) = 1;
    opt.traces(6) = ~p.expOpt.traces(6);
    pushbutton_expTraces_Callback({false},[],h_fig);
    set_TP_asciiExpOpt(opt,h_fig);
    pushbutton_next_Callback({p.dumpdir,mash_files{f}},[],h_fig);

    % test parameters export to separate file
    opt.traces(3:7) = false;
    opt.traces(8) = 1;
    pushbutton_expTraces_Callback({false},[],h_fig);
    set_TP_asciiExpOpt(opt,h_fig);
    pushbutton_next_Callback({p.dumpdir,mash_files{f}},[],h_fig);

    % test figure export to different formats
    disp(cat(2,prefix,'>> test figure options...'));
    opt = p.expOpt;
    opt.fig{1}(1) = true;
    for fmt = 1:nFigFmt
        if fmt==p.expOpt.fig{1}(2)
            continue
        end
        opt.fig{1}(2) = fmt;
        pushbutton_expTraces_Callback({false},[],h_fig);
        set_TP_asciiExpOpt(opt,h_fig);
        pushbutton_next_Callback({p.dumpdir,mash_files{f}},[],h_fig);
    end

    % test different figure layout and figure preview
    exp_fig = cat(2,p.dumpdir,filesep,fig_files{f});
    opt.fig{1}(12) = true;
    pushbutton_expTraces_Callback({false},[],h_fig);

    opt.fig{1}([4,5,8]) = [true,false,false];
    opt.fig{2} = cat(2,exp_fig,'_subImg.png');
    set_TP_asciiExpOpt(opt,h_fig);

    opt.fig{1}([4,5,8]) = [false,true,false];
    opt.fig{2} = cat(2,exp_fig,'_top.png');
    set_TP_asciiExpOpt(opt,h_fig);

    opt.fig{1}([4,5,8]) = [false,false,true];
    opt.fig{2} = cat(2,exp_fig,'_bottom.png');
    set_TP_asciiExpOpt(opt,h_fig);

    opt.fig{1}([4,5,8]) = [true,true,true];
    opt.fig{1}(10) = false;
    opt.fig{2} = cat(2,exp_fig,'_noHist.png');
    set_TP_asciiExpOpt(opt,h_fig);

    opt.fig{1}(10) = true;
    opt.fig{1}(11) = false;
    opt.fig{2} = cat(2,exp_fig,'_noDiscr.png');
    set_TP_asciiExpOpt(opt,h_fig);

    pushbutton_cancel_Callback(q.pushbutton_cancel,[],h_fig);

    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
end
