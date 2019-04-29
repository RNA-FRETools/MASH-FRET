function pointITT(obj, evd, h_fig)

h = guidata(h_fig);

nLasers = h.param.movPr.itg_nLasers;
int_ave = h.param.movPr.itg_ave;
perSec = h.param.movPr.perSec;
nPix = h.param.movPr.itg_n;
aDim = h.param.movPr.itg_dim;

if nLasers>h.movie.framesTot
    nLasers = h.movie.framesTot;
end

newPnt = floor(get(h.axes_movie, 'CurrentPoint'))+0.5;
newPnt = newPnt(1,[1 2]);

pleaseWait('start', h_fig);

fDat{1} = [h.movie.path h.movie.file];
fDat{2}{1} = h.movie.speCursor;
if isfield(h, 'movie') && ~isempty(h.movie.movie)
    fDat{2}{2} = h.movie.movie;
else
    fDat{2}{2} = [];
end
fDat{3} = [h.movie.pixelY h.movie.pixelX];
fDat{4} = h.movie.framesTot;
[o,data] = create_trace(newPnt,aDim,nPix,fDat);

str_ave = [];
str_sec = [];
if perSec
    str_sec = ' /s';
    data = data/h.movie.cyctime;
end
if int_ave
    str_ave = ' /pix. ';
    data = data/nPix;
end

pleaseWait('close', h_fig);

time_ax = h.movie.cyctime*((1:size(data,1))');

ITT = cell(1,nLasers);
for i = 1:nLasers
    ITT{i}(:,1) = time_ax(i:nLasers:end,1)*h.movie.cyctime;
    ITT{i}(:,2) = data(i:nLasers:end,1);
end

h_figBG_mov = figure('Color', [1 1 1], 'NumberTitle', 'off', ...
    'Name', cat(2,'Intensity-time trace at coordinates (',...
    num2str(newPnt(1)),',',num2str(newPnt(2)),')'), 'CloseRequestFcn', ...
    {@figureBGmov_CloseRequestFcn}, 'SelectionType', 'Normal');

posFig = get(h_figBG_mov, 'Position');
set(h_figBG_mov, 'Position', [posFig(1) posFig(2) 500 200]);
h_axes = axes('Units', 'pixels', 'OuterPosition', [0 0 500 200], ...
    'NextPlot', 'add');
clr = [0 0 1
    1 0 0
    0 1 0
    0 0 0];
leg_str = {};
for i = 1:nLasers
    leg_str = cat(2,leg_str,cat(2,'laser ',num2str(i)));
    if size(clr,1)<i
        clr = cat(1,clr,rand(1,3));
    end
    if size(ITT{i},1) > 1
        plot(h_axes, ITT{i}(:,1), ITT{i}(:,2), 'Color', clr(i,:));
    else
        plot(h_axes, [0 ITT{i}(1,1)], [ITT{i}(1,2) ITT{i}(1,2)], 'Color', ...
            clr(i,:));
    end
end

if size(ITT{i},1) > 1
    xlim(h_axes, [ITT{i}(1,1) ITT{i}(end,1)]);
else
    xlim(h_axes, [0 ITT{i}(1,1)]);
end

ylim(h_axes, 'auto');
xlabel(h_axes, 'time (s)');
ylabel(h_axes, ['intensity (counts' str_ave str_sec ')']);
legend(h_axes, leg_str);
grid on;

setProp(get(obj, 'Children'), 'Units', 'normalized');

guidata(h_fig, h);

export = questdlg('Do you want to export these data to the workspace?', ...
    'Export time trace', 'Yes', 'No', 'Yes');

if strcmp(export, 'Yes')
    export2wsdlg({'Intensity-time trace'}, {'variable name'}, ...
        {ITT});
end

function figureBGmov_CloseRequestFcn(obj, evd)
set(obj, 'Visible', 'off');
