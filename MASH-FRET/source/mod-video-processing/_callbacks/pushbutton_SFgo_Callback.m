function pushbutton_SFgo_Callback(obj, evd, h_fig)

% collect parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
def = p.proj{p.curr_proj}.VP.def;
avimg = curr.res_plot{2};
meth = curr.gen_crd{2}{1}(1);
bgfilt = curr.edit{1}{4};

% control average image
if ~all(~cellfun('isempty',avimg))
    setContPan(['No average image detected. Please calculate or load the ',...
        'average image first.'],'error',h_fig);
    return
end

% control spotfinder method
if meth==1
    return
end

% display process
setContPan('Start a spotfinder procedure...','process',h_fig);

% reset results
curr.gen_crd{2}{4} = def.gen_crd{2}{4}; % uncharted
curr.gen_crd{2}{5} = def.gen_crd{2}{5}; % final sorted
curr.res_crd{1} = def.res_crd{1}; % spots coordinates

% plot SF coordinates
curr.plot{1}(2) = 1;

% check if any image filter is applied
isBgCorr = ~isempty(bgfilt);

% filter image
if isBgCorr
    for c = 1:numel(aveimg)
        avimg{c} = updateBgCorr(avimg{c}, p, h_fig);
    end
end

% find spots
curr = updateSF(avimg, false, curr, h_fig);

% set coordinates to transform
spots = cell(1,nChan);
for c = 1:nChan
    if ~isempty(curr.gen_crd{2}{5}{c})
        spots{c} = curr.gen_crd{2}{5}{c}(:,[1,2]);
    end
end
curr.res_crd{1} = spots;

% reset coordinates file to transform
curr.gen_crd{3}{1}{2} = '';

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
p.proj{p.curr_proj}.VP.prm.gen_crd{2} = curr.gen_crd{2};
p.proj{p.curr_proj}.VP.prm.res_crd = curr.res_crd;
h.param = p;
guidata(h_fig, h);

% bring average image plot tab front
bringPlotTabFront('VPave',h_fig);

% refresh calculations, plot and GUI
updateFields(h_fig, 'imgAxes');

% display success
setContPan('Spotfinder procedure successfully completed!','success',h_fig);
