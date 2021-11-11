function ud_trajImportOpt(h_fig)

proj = h_fig.UserData;
nChan = proj.nb_channel;
nExc = proj.nb_excitations;
FRET = proj.FRET;
opt = proj.traj_import_opt;

% control trajectory import
h = guidata(h_fig);
if ~(isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct))
    return
end

% collect import options
icol1 = opt{1}{1}(5);
icol2 = opt{1}{1}(6);
rowwise = opt{1}{1}(7);
fretcol1 = opt{1}{1}(10);
fretcol2 = opt{1}{1}(11);
skipfretcol = opt{1}{1}(12);
tcol = opt{1}{1}(4);
tcol_exc = opt{1}{2};
icol_exc = opt{1}{3};

% adjust ALEX import format
if nExc==1
    rowwise = 1;
end

% adjust laser-specific intensity columns
if size(icol_exc,1)<nExc
    icol_exc = cat(1,icol_exc,...
        repmat(icol_exc(end,:),[nExc-size(icol_exc,1),1]));
end

% adjust laser-specific time columns
if numel(tcol_exc)<nExc
    tcol_exc = cat(2,tcol_exc,...
        repmat(tcol_exc(end),[1,nExc-numel(tcol_exc)]));
end

% adjust columns nb to last file size
fdat = h.table_fstrct.UserData;
isfdat = ~isempty(fdat);
if isfdat
    C = size(fdat,2);
    icol2(icol2==0) = C;
    fretcol2(fretcol2==0) = C;
    tcol(tcol==0) = C;
    tcol_exc(tcol_exc==0) = C;
    icol_exc(icol_exc(:,2)==0,2) = C;
    
    icol1(icol1==0) = 1;
    fretcol1(fretcol1==0) = 1;
    icol_exc(icol_exc(:,1)==0,1) = 1;
    
    icol1(icol1>C) = C;
    icol2(icol2>C) = C;
    fretcol1(fretcol1>C) = C;
    fretcol2(fretcol2>C) = C;
    tcol(tcol>C) = C;
    tcol_exc(tcol_exc>C) = C;
    icol_exc(icol_exc>C) = C;
    
    % adjust intensity columns to number of channels
    if C<nChan
        icol1 = 0;
        icol2 = 0;
        icol_exc(:,1) = 0;
        icol_exc(:,2) = 0;
    else
        if icol1>icol2
            icol2 = icol1+nChan-1;
        end
        irange = icol1:icol2;
        if mod(numel(irange),nChan)>0
            icol2 = icol1+nChan-1;
            if icol2>C
                icol2 = C;
                icol1 = icol2-nChan+1;
            end
        end
        for l = 1:nExc
            if icol_exc(l,1)>icol_exc(l,2)
                icol_exc(l,2) = icol_exc(l,1)+nChan-1;
            end
            irange = icol_exc(l,1):icol_exc(l,2);
            if mod(numel(irange),nChan)>0
                icol_exc(l,2) = icol_exc(l,1)+nChan-1;
                if icol_exc(l,2)>C
                    icol_exc(l,2) = C;
                    icol_exc(l,1) = icol_exc(l,2)-nChan+1;
                end
            end
        end
    end

    % adjust FRET state columns
    nPair = size(FRET,1);
    if C<nPair
        fretcol1 = 0;
        fretcol2 = 0;
        skipfretcol= 0;
    else
        if fretcol1>fretcol2
            fretcol2 = fretcol1+(nPair-1)*(skipfretcol+1);
        end
        fretrange = fretcol1:(skipfretcol+1):fretcol2;
        if numel(fretrange)>C
            skipfretcol = 0;
            fretrange = fretcol1:fretcol2;
        end
        if mod(numel(fretrange),nPair)>0
            fretcol2 = fretcol1+(nPair-1)*(skipfretcol+1);
            if fretcol2>C
                fretcol2 = C;
                fretcol1 = fretcol2-(nPair-1)*(skipfretcol+1);
            end
        end
    end
end

% save modifications
opt{1}{1}(4) = tcol;
opt{1}{1}(5) = icol1;
opt{1}{1}(6) = icol2;
opt{1}{1}(7) = rowwise;
opt{1}{1}(10) = fretcol1;
opt{1}{1}(11) = fretcol2;
opt{1}{1}(12) = skipfretcol;
opt{1}{2} = tcol_exc(1:nExc);
opt{1}{3} = icol_exc(1:nExc,:);

% adjust sampling time
proj = getExpSetSamplingTime(opt,proj,h_fig);

% save modifications
proj.traj_import_opt = opt;
h_fig.UserData = proj;

