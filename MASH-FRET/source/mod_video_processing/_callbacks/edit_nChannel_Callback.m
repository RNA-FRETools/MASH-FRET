function edit_nChannel_Callback(obj, evd, h_fig)

nC = round(str2num(get(obj, 'String')));
if ~(numel(nC)==1 && ~isnan(nC) && nC>0)
    updateActPan('Number of channel must be > 0.', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% adjust processing parameters
if nC==p.nChan
    return
end
p.nChan = nC;
p = ud_VP_nChan(p);

% adjust video parameters
sub_w = round(h.movie.pixelX/nC);
h.movie.split = (1:nC-1)*sub_w;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% Update panels and plot
updateFields(h_fig,'imgAxes');


