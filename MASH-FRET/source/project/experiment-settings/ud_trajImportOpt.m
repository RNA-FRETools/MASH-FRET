function ud_trajImportOpt(h_fig)

h = guidata(h_fig);
proj = h_fig.UserData;
nChan = proj.nb_channel;
nExc = proj.nb_excitations;
nPair = size(proj.FRET,1);
opt = proj.traj_import_opt;
if isempty(opt)
    return
end

% collect import options
tcol = opt{1}{1}(4);
rowwise = opt{1}{1}(5); 
tcol_exc = opt{1}{2};
icol = opt{1}{3};
icol_exc = opt{1}{4};
fretcol = opt{1}{5};

% adjust ALEX import format
if nExc==1
    rowwise = 1;
end

% adjust laser-specific time columns
if numel(tcol_exc)<nExc
    tcol_exc = cat(2,tcol_exc,...
        repmat(tcol_exc(end),[1,nExc-numel(tcol_exc)]));
end

% adjust intensity columns
if size(icol,1)<nChan
    icol = cat(1,icol,repmat(icol(end,:),[nChan-size(icol,1),1]));
end

% adjust laser-specific intensity columns
if size(icol_exc,1)<nChan
    icol_exc = cat(1,icol_exc,...
        repmat(icol_exc(end,:,:),[nChan-size(icol_exc,1),1,1]));
end
if size(icol_exc,3)<nExc
    icol_exc = cat(3,icol_exc,...
        repmat(icol_exc(:,:,end),[1,1,nExc-size(icol_exc,3)]));
end

% adjust FRET states columns
if size(fretcol,1)==0
    fretcol = [1,1,0];
end
if size(fretcol,1)<nPair
    fretcol = cat(1,fretcol,...
        repmat(fretcol(end,:),[nPair-size(fretcol,1),1]));
end

% adjust columns nb to last file size
fdat = [];
if isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct)
    fdat = h.table_fstrct.UserData;
end
isfdat = ~isempty(fdat);
if isfdat
    C = size(fdat,2);
    icol(icol(:,1)==0 | icol(:,1)>C,1) = C;
    icol(icol(:,2)==0 | icol(:,2)>C,2) = C;
    fretcol(fretcol(:,1)==0 | fretcol(:,1)>C,1) = C;
    fretcol(fretcol(:,2)==0 | fretcol(:,2)>C,2) = C;
    tcol(tcol==0 | tcol>C) = C;
    tcol_exc(tcol_exc==0 | tcol_exc>C) = C;
    for l = 1:nExc
        icol_exc(icol_exc(:,1,l)==0 | icol_exc(:,1,l)>C,1,l) = C;
        icol_exc(icol_exc(:,2,l)==0 | icol_exc(:,2,l)>C,2,l) = C;
    end
end
icol(icol(:,1)>icol(:,2),2) = icol(icol(:,1)>icol(:,2),1);
fretcol(fretcol(:,1)>fretcol(:,2),2) = ...
    fretcol(fretcol(:,1)>fretcol(:,2),1);
for l = 1:nExc
    icol_exc(icol_exc(:,1,l)>icol_exc(:,2,l),2,l) = ...
        icol_exc(icol_exc(:,1,l)>icol_exc(:,2,l),1,l);
end

% save modifications
opt{1}{1}(4) = tcol;
opt{1}{1}(5) = rowwise; 
opt{1}{2} = tcol_exc(1:nExc);
opt{1}{3} = icol(1:nChan,:);
opt{1}{4} = icol_exc(1:nChan,:,1:nExc);
opt{1}{5} = fretcol(1:nPair,:);

% adjust sampling time
proj = getExpSetSamplingTime(opt,proj,h_fig);

% save modifications
proj.traj_import_opt = opt;
h_fig.UserData = proj;

