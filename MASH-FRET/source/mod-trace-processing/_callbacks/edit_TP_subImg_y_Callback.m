function edit_TP_subImg_y_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
refocus = p.proj{proj}.TP.fix{1}(5);
nC = p.proj{proj}.nb_channel;
itg_dim = p.proj{proj}.pix_intgr(1);
viddat = p.proj{proj}.movie_dat;
vidfile = p.proj{proj}.movie_file;
viddim = p.proj{proj}.movie_dim;

multichanvid = numel(viddim)==1;

if refocus
    updateActPan('Impossible to modify coordinates in "recenter" mode', ...
        h_fig, 'error');
    return
end

chan = get(h.popupmenu_TP_subImg_channel,'value');

if multichanvid
    mov = 1;
else
    mov = chan;
end
lim = [0,viddim{mov}(1)];

val = str2num(get(obj,'string'));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
        (ceil(val) - floor(itg_dim/2)) > lim(1) && ...
        (ceil(val) + floor(itg_dim/2)) < lim(2))

    set(obj,'backgroundcolor',[1 0.75 0.75]);

    updateActPan(['y-coordinates must be > ' ...
        num2str(lim(1)+floor(itg_dim/2)) ' and < ' ...
        num2str(lim(2)-floor(itg_dim/2))], h_fig, 'error');

    return
end

if isequal(p.proj{proj}.coord(mol,2*chan),val)
    return
end

% display process
setContPan('Modify molecule position...', 'process', h_fig);

p.proj{proj}.coord(mol,2*chan) = val;
coord = p.proj{proj}.coord(mol,(2*chan-1):2*chan);
aDim = p.proj{proj}.pix_intgr(1);
nPix = p.proj{proj}.pix_intgr(2);
nFrames = viddat{mov}{3};
fDat{1} = vidfile{mov};
fDat{2}{1} = viddat{mov}{1};
if isFullLengthVideo(vidfile{mov},h_fig)
    fDat{2}{2} = h.movie.movie;
else
    fDat{2}{2} = [];
end
fDat{3} = viddat{mov}{2};
fDat{4} = nFrames;

[coord,trace] = create_trace(coord,aDim,nPix,fDat);

nFrames = size(p.proj{proj}.intensities,1);
nExc = size(p.proj{proj}.intensities,3);
I = zeros(nFrames, 1, nExc);
for i = 1:nExc
    I(:,1,i) = trace(i:nExc:nFrames*nExc,:);
end
i_mol = (mol-1)*nC+chan;
p.proj{proj}.intensities(1:nFrames,i_mol,1:nExc) = I;

p.proj{proj}.TP.prm{mol} = {};

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');

% display success
setContPan('Molecule positions were successfully centered!','success',...
    h_fig);
