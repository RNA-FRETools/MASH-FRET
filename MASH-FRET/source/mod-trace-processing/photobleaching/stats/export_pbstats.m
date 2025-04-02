function export_pbstats(~,~,fig,dat)

% retrieve data and fit results
h = guidata(fig);
h0 = guidata(h.fig_MASH);
p = h0.param;
proj = p.curr_proj;
insec = p.proj{proj}.time_in_sec;
projnm = p.proj{proj}.exp_parameters{1,2};
src = p.proj{proj}.folderRoot;
if src(end)==filesep
    src = src(1:end-1);
end

switch dat
    case 'bleach'
        ax = h.axes_bleachstats;
        strdat = 'bleach';
    case 'blink'
        ax = h.axes_blinkstats;
        strdat = 'blink';
end
res = ax.UserData;

% get file name
fnamedef = [src,filesep,projnm,'_stats.txt'];
[fname,src] = uiputfile(fnamedef);
if isequal(fname,0)
    return
end
cd(src);
[~,fname,~] = fileparts(fname);
fname = [fname,'_',strdat,'.txt'];

% export histogram and fit results
if isempty(res.cnt)
    disp('Can not export: no time data is available');
    return
end
f = fopen([src,filesep,fname],'Wt');
if f==-1
    disp(['Can not open file ',src,filesep,fname]);
    return
end
streqmean = sprintf('%.2f*exp(-t/%.2f)',res.A,res.tau);
streqlow = sprintf('(%.2f*-%.2f)exp(-t/(%.2f-%.2f))',res.A,res.dA,res.tau,...
    res.dtau);
strequp = sprintf('(%.2f*+%.2f)exp(-t/(%.2f+%.2f))',res.A,res.dA,res.tau,...
    res.dtau);
if insec
    strun = 'seconds';
else
    strun = 'time steps';
end
fprintf(f,['bin centers (',strun,')\tbin edges (',strun,')\tcount\t',...
    '1-CDF\tfit ',streqmean,'\tlower bound ',streqlow,'\tupper bound ',...
    strequp,'\n']);
fprintf(f,'%d\t%d\t%i\t%d\t%d\t%d\t%d\n',...
    [[res.bincenter,NaN];res.binedges;[res.cnt,NaN];[res.cmplP,NaN];...
    [res.fit,NaN];[res.lowfit,NaN];[res.upfit,NaN]]);
fclose(f);
disp('File was successfully exported!');