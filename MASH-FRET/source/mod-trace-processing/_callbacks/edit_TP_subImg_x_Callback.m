function edit_TP_subImg_x_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nC = p.proj{proj}.nb_channel;
itg_dim = p.proj{proj}.pix_intgr(1);
res_x = p.proj{proj}.movie_dim(1);
refocus = p.proj{proj}.TP.fix{1}(5);

if refocus
    setContPan('Impossible to modify coordinates in "recenter" mode',...
        'error',h_fig);
    return
end
    
val = str2num(get(obj,'string'));
sub_w = round(res_x/nC);
lim = [0 (1:nC-1)*sub_w res_x];

chan = get(h.popupmenu_TP_subImg_channel,'value');

if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
        (ceil(val) - floor(itg_dim/2)) > lim(chan) && ...
        (ceil(val) + floor(itg_dim/2)) < lim(chan+1))

    set(obj,'backgroundcolor',[1 0.75 0.75]);

    updateActPan(['x-coordinates must be > ' ...
        num2str(lim(chan)+floor(itg_dim/2)) ' and < ' ...
        num2str(lim(chan+1)-floor(itg_dim/2))], h_fig, 'error');

    return
end

if isequal(p.proj{proj}.coord(mol,2*chan-1),val)
    return
end

% display process
setContPan('Modify molecule position...', 'process', h_fig);

p.proj{proj}.coord(mol,2*chan-1) = val;
coord = p.proj{proj}.coord(mol,(2*chan-1):2*chan);
aDim = p.proj{proj}.pix_intgr(1);
nPix = p.proj{proj}.pix_intgr(2);
nFrames = p.proj{proj}.movie_dat{3};
fDat{1} = p.proj{proj}.movie_file;
fDat{2}{1} = p.proj{proj}.movie_dat{1};
if isFullLengthVideo(p.proj{proj}.movie_file,h_fig)
    fDat{2}{2} = h.movie.movie;
else
    fDat{2}{2} = [];
end
fDat{3} = [p.proj{proj}.movie_dat{2}(1) p.proj{proj}.movie_dat{2}(2)];
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
setContPan('Molecule position was successfully modified!','success',h_fig);
