function pushbutton_expTrsfCoord_Callback(obj,evd,h_fig)
% pushbutton_expTrsfCoord_Callback([],[],h_fig)
% pushbutton_expTrsfCoord_Callback(file,[],h_fig)
%
% h_fig: handle to main figure
% file: {1-by-2} cell array with:
%  file{1}: file locations
%  file{2}: file name

% default
defbfname = 'frame_t_0';

% retrieve parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
projfile = p.proj{p.curr_proj}.proj_file;
projtle = p.proj{p.curr_proj}.exp_parameters{1,2};
vidfile = p.proj{p.curr_proj}.movie_file;
coordtr = p.proj{p.curr_proj}.VP.curr.res_crd{4};
coordfile = p.proj{p.curr_proj}.VP.curr.gen_crd{3}{1}{2};

% control transformed coordinates
if isempty(coordtr)
    setContPan(['No transformed coordinates detected. Please start a ',...
        'transformation procedure first.'],'error',h_fig);
    return
end

% get destination coordinates file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if pname(end)~=filesep
        pname = [pname,filesep];
    end
else
    if ~isempty(coordfile)
        [o,name,o] = fileparts(coordfile);
    elseif ~isempty(projfile)
        [o,name,o] = fileparts(projfile);
    else
        [o,name,o] = fileparts(vidfile);
        if strcmp(name,defbfname)
            name = projtle;
        end
    end
    fname = [setCorrectPath('transformed', h_fig) name '.coord'];
    [fname,pname,o] = uiputfile({...
        '*.coord','Transformed coordinates files(*.coord)'; ...
        '*.*','All files(*.*)'},'Export coordinates', fname);
end
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname = getCorrName([fname '.coord'], pname, h_fig);
if ~sum(fname)
    return
end

% display progress
setContPan('Write transformed coordinates to file...','process',h_fig);

% save coordinates to file
str_hd = [];
str_fmt = [];
for c = 1:nChan
    str_hd = cat(2,str_hd,'x_',num2str(c),'\ty_',num2str(c),'\t');
    str_fmt = cat(2,str_fmt,'%d\t%d\t');
end
str_hd(end) = 'n';
str_fmt(end) = 'n';
f = fopen([pname fname], 'Wt');
fprintf(f, str_hd);
fprintf(f, str_fmt, coordtr');
fclose(f);

% display succes
setContPan(['Transformed coordinates successfully saved to file: ',...
    pname,fname], 'success', h_fig);
