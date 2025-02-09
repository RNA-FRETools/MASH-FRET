function coordfile = saveSpots(p,h_fig,varargin)
% coordfile = saveSpots(p,h_fig)
% coordfile = saveSpots(p,h_fig,pname,fname)
%
% Save spots coordinates to *.spots file and image of spots to *.png file.
%
% p: structure to update with SF results
% h_fig: handle to main figure
% pname: desired destination folder
% fname: desired destination file
% coordfile: final destination file

% Last update by MH, 23.4.2019: correct typos in exported file

% default
defbfname = 'frame_t_0';

% initialize output
coordfile = [];

% collect parameters
nChan = p.proj{p.curr_proj}.nb_channel;
projfile = p.proj{p.curr_proj}.proj_file;
projtle = p.proj{p.curr_proj}.exp_parameters{1,2};
vidfile = p.proj{p.curr_proj}.movie_file;
expT = p.proj{p.curr_proj}.sampling_time;
persec = p.proj{p.curr_proj}.cnt_p_sec;
curr = p.proj{p.curr_proj}.VP.curr;
def = p.proj{p.curr_proj}.VP.def;
coordsf = curr.gen_crd{2}{5};

% control SF coordinates
if isequal(coordsf,def.gen_crd{2}{5})
    return
end

% get destination file name
if ~isempty(varargin)
    pname = varargin{1};
    fname = varargin{2};
else
    if ~isempty(projfile)
        [o,name,o] = fileparts(projfile);
    else
        [o,name,o] = fileparts(vidfile{1});
    end
    if strcmp(name,defbfname)
        name = projtle;
    end
    defName = [setCorrectPath('spotfinder', h_fig) name '.spots'];
    [fname,pname,o] = uiputfile({ ...
        '*.spots', 'Coordinates file(*.spots)'; ...
        '*.*', 'All files(*.*)'}, 'Export coordinates', defName);
end
if ~sum(fname)
    return
end
[o,fname,o] = fileparts(fname);
coordfile = getCorrName([fname '.spots'], pname, h_fig);
if ~sum(coordfile)
    coordfile = [];
    return
end
cd(pname);
[o,fname,o] = fileparts(coordfile);
coordfile = [pname fname '.spots'];

% display process
setContPan('Write spots coordinates to file...','process',h_fig);

% get spots coordinates
spots = [];
for c = 1:nChan
    spots = cat(1,spots,[coordsf{c},repmat(c,[size(coordsf{c},1),1])]);
end

% convert intensities to proper units
if persec
    spots(:,3) = spots(:,3)/expT;
    if size(spots,2)>4
        spots(:,8) = spots(:,8)/expT;
    end
    un = '(a.u./s)';
else
    un = '(a.u.)';
end

% export spots
if size(spots,2)<=4 % no gaussian fit
    str_header = 'x\ty\tI\tchannel';
    str_fmt = '%d\t%d\t%d\t%i';
else % gaussian fit
    str_header = ['x\ty\tI',un,'\tasymmetry\twidth\theight\ttheta\t',...
        'z-offset',un,'\tchannel'];
    str_fmt = '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%i';
end
str_header = cat(2,str_header, '\n');
str_fmt = cat(2,str_fmt, '\n');
f = fopen(coordfile, 'Wt');
fprintf(f, str_header);
fprintf(f, str_fmt, spots');
fclose(f);

% display success
setContPan(['Spots coordinates have been successfully written to ',...
    'file: ',coordfile], 'success', h_fig);
