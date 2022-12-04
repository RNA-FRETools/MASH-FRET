function pushbutton_trSaveRef_Callback(obj,evd,h_fig)
% pushbutton_trSaveRef_Callback([],[],h_fig)
% pushbutton_trSaveRef_Callback(file,[],h_fig)
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
coordref = p.proj{p.curr_proj}.VP.curr.res_crd{3};
imgfile = p.proj{p.curr_proj}.VP.curr.gen_crd{3}{2}{6};

% control reference coordinates
if isempty(coordref)
    setContPan(['No reference coordinates detected. Please map ',...
        'coordinates first.'],'error',h_fig);
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
    if ~isempty(imgfile)
        [o,name,o] = fileparts(imgfile{1});
    elseif ~isempty(projfile)
        [o,name,o] = fileparts(projfile);
    else
        [o,name,o] = fileparts(vidfile{1});
    end
    if strcmp(name,defbfname)
        name = projtle;
    end
    fname = [setCorrectPath('mapping', h_fig) name '.map'];
    [fname,pname,o] = uiputfile({'*.map','Mapped coordinates files(*.map)'; ...
        '*.*','All files(*.*)'},'Export coordinates', fname);
end
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname = getCorrName([fname '.map'], pname, h_fig);
if ~sum(fname)
    return
end

% display process
setContPan('Write reference coordinates to file...','process',h_fig);

% organize coordinates in a row-wise manner
coord = zeros([numel(coordref)/2 2]);
if ~isempty(coordref)
    for i = 1:nChan
        coord(i:nChan:end,:) = coordref(:,2*i-1:2*i);
    end
end
if isempty(coord)
    return
end

% save coordinates to file
f = fopen([pname fname], 'Wt');
fprintf(f, 'x\ty\n');
fprintf(f, '%d\t%d\n', coordref');
fclose(f);

% display succes
setContPan(['Reference coordinates successfully saved to file: ',pname,...
    fname], 'success', h_fig);
