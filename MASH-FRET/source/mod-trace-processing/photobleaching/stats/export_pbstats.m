function export_pbstats(fle,~,fig,dat)

% retrieve data and fit results
h = guidata(fig);
h0 = guidata(h.fig_MASH);
p = h0.param;
proj = p.curr_proj;
insec = p.proj{proj}.time_in_sec;
projnm = p.proj{proj}.exp_parameters{1,2};
chanExc = p.proj{proj}.chanExc;
lbl = p.proj{proj}.labels;
src = p.proj{proj}.folderRoot;
if src(end)==filesep
    src = src(1:end-1);
end

em = h.popup_emitter.Value;
emlst = find(chanExc>0);

switch dat
    case 'bleach'
        axhdl = h.axes_bleachstats;
        strdat = {'bleach'};
    case 'blink'
        axhdl = [h.axes_blinkon,h.axes_blinkoff];
        strdat = {'blink-on','blink-off'};
    case 'all'
        axhdl = [h.axes_bleachstats,h.axes_blinkon,h.axes_blinkoff];
        strdat = {'bleach','blink-on','blink-off'};
end
    
% get file name
if ischar(fle)
    [src,fname0,~] = fileparts(fle);
else
    fnamedef = [src,filesep,projnm,'_stats.txt'];
    [fname0,src] = uiputfile(fnamedef);
    if isequal(fname0,0)
        return
    end
    cd(src);
end
[~,fname0,~] = fileparts(fname0);

for a = 1:numel(axhdl)
    res = axhdl(a).UserData{em};
    fname = [fname0,'_',strdat{a},'_',lbl{emlst(em)},'.txt'];
    
    % check data to export
    if isempty(res.cnt)
        setContPan('Can not export: no time data is available','error',...
            h.fig_MASH);
        return
    end
    if isempty(res.fit)
        isfit = false;
    else
        isfit = true;
    end
    
    % write data in file
    f = fopen([src,filesep,fname],'Wt');
    if f==-1
        setContPan(['Can not open file ',src,filesep,fname],'error',...
            h.fig_MASH);
        return
    end
    if insec
        strun = 'seconds';
    else
        strun = 'time steps';
    end
    if isfit
        streqmean = sprintf('%.2f*exp(-t/%.2f)',res.A,res.tau);
        streqlow = sprintf('(%.2f-%.2f)exp(-t/(%.2f-%.2f))',res.A,res.dA,res.tau,...
            res.dtau);
        strequp = sprintf('(%.2f+%.2f)exp(-t/(%.2f+%.2f))',res.A,res.dA,res.tau,...
            res.dtau);
        fprintf(f,['bin centers (',strun,')\tbin edges (',strun,')\tcount\t',...
            '1-CDF\tfit ',streqmean,'\tlower bound ',streqlow,'\tupper bound ',...
            strequp,'\n']);
        fprintf(f,'%d\t%d\t%i\t%d\t%d\t%d\t%d\n',...
            [[res.bincenter,NaN];res.binedges;[res.cnt,NaN];[res.cmplP,NaN];...
            [res.fit,NaN];[res.lowfit,NaN];[res.upfit,NaN]]);
    else
        fprintf(f,['bin centers (',strun,')\tbin edges (',strun,')\tcount\t',...
            '1-CDF\n']);
        fprintf(f,'%d\t%d\t%i\t%d\n',...
            [[res.bincenter,NaN];res.binedges;[res.cnt,NaN];[res.cmplP,NaN]]);
    end
    fclose(f);
end

% display success
switch dat
    case 'bleach'
        str = 'Photobleaching';
    case 'blink'
        str = 'Blinking';
    case 'all'
        str = 'Photobleaching and blinking';
end
if isfit
    setContPan(sprintf([str,' statistics were successfully ',...
        'exported to file: %s'],[src,filesep,fname]),'success',h.fig_MASH);
else
    setContPan(['No fit result is available for export, but ',...
        sprintf([str,' histogram was successfully exported to file: %s'],...
        [src,filesep,fname])],'warning',h.fig_MASH);
end