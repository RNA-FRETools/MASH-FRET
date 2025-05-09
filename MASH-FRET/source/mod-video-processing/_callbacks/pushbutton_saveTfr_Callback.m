function pushbutton_saveTfr_Callback(obj, evd, h_fig)
% pushbutton_saveTfr_Callback([],[],h_fig)
% pushbutton_saveTfr_Callback(outfile,[],h_fig)
%
% h_fig: handle to main figure
% outfile: {1-by-2} destination folder and file

% default
defbfname = 'frame_t_0';

% collect parameters
h = guidata(h_fig);
p = h.param;
projfile = p.proj{p.curr_proj}.proj_file;
projtle = p.proj{p.curr_proj}.exp_parameters{1,2};
vidfile = p.proj{p.curr_proj}.movie_file;
tr = p.proj{p.curr_proj}.VP.curr.res_crd{2};
coordreffile = p.proj{p.curr_proj}.VP.curr.gen_crd{3}{2}{2};

% control transformation
if isempty(tr)
    setContPan(['No transformation detected. Please calculate or import a',...
        ' transformation.'],'error',h_fig);
    return
end

% get file name
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname =[pname,filesep];
    end
else
    if ~isempty(coordreffile)
        [o,name,o] = fileparts(coordreffile);
    elseif ~isempty(projfile)
        [o,name,o] = fileparts(projfile);
    else
        [o,name,o] = fileparts(vidfile{1});
    end
    if strcmp(name,defbfname)
        name = projtle;
    end
    fname = [setCorrectPath('transformed', h_fig) name '.mat'];
    [fname,pname,o] = uiputfile({'*.mat', 'Matlab files(*.mat)'; ...
        '*.*', 'All files(*.*)'}, 'Export transformation', fname);
end
if ~sum(fname)
    return
end
cd(pname);
[o,name,o] = fileparts(fname);
fname_tr = getCorrName([name '_trs.mat'], pname, h_fig);
if ~sum(fname_tr)
    return
end

% display process
setContPan('Write transformation to file...','process',h_fig);

% save transformation to file
save([pname fname_tr],'-mat','tr');

% set GUI to proper values
ud_VP_coordTransfPan(h_fig);

% display success
setContPan(['Transformation successfully saved to file: ',pname,fname_tr],...
    'success',h_fig);
