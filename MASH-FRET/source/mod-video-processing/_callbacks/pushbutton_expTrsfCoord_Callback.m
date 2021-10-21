function pushbutton_expTrsfCoord_Callback(obj,evd,h_fig)
% pushbutton_expTrsfCoord_Callback([],[],h_fig)
% pushbutton_expTrsfCoord_Callback(file,[],h_fig)
%
% h_fig: handle to main figure
% file: {1-by-2} cell array with:
%  file{1}: file locations
%  file{2}: file name

% retrieve parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
coordtr = p.proj{p.curr_proj}.VP.curr.res_crd{4};

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
    [o,defName,o] = fileparts(q.refimgfile);
    defName = [setCorrectPath('transformed', h_fig) defName '.coord'];
    [fname,pname,o] = uiputfile({...
        '*.coord','Transformed coordinates files(*.coord)'; ...
        '*.*','All files(*.*)'},'Export coordinates', defName);
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
setContPan(['Transformed coordinates were successfully saved to file: ',...
    pname,fname], 'success', h_fig);
