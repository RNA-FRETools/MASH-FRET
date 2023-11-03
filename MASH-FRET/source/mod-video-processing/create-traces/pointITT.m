function pointITT(obj, evd, h_fig)
% pointITT([], [], h_fig)
% pointITT(opt, [], h_fig)
%
% h_fig: handle to main figure
% opt: {1-by-2} cell array that contains:
%  {1}: [1-by-2] x- and y-coordinates
%  {2}: destination file
%
% Create laser-specific intensity-time traces at click position or at input coordinates and plot.
% pointITT can be called from MASH-FRET's GUI or from a test routine.
% Traces can be exported to MATLAB's workspace at the end of the procedure if pointITT is called from MASH-FRET's GUI
% Plot is exported to .png image file if pointITT is called from a test routine.

h = guidata(h_fig);
p = h.param;

h_axes0 = gca;

if iscell(obj)
    newPnt = obj{1};
    file_out = obj{2};
    fromRoutine = true;
else
    newPnt = floor(get(h_axes0, 'CurrentPoint'))+0.5;
    newPnt = newPnt(1,[1 2]);
    fromRoutine = false;
end

nExc = p.proj{p.curr_proj}.nb_excitations;
expT = p.proj{p.curr_proj}.frame_rate;
persec = p.proj{p.curr_proj}.cnt_p_sec;
vidfile = p.proj{p.curr_proj}.movie_file;
viddat = p.proj{p.curr_proj}.movie_dat;
curr = p.proj{p.curr_proj}.VP.curr;
pxdim = 1;
npix = 1;

% display process
setContPan('Generating intensity-time traces...','process',h_fig);

h_tab = h_axes0.Parent;
h_tg = h_tab.Parent;
mov = find(h_tg.Children==h_tab);

if h_axes0==h.axes_VP_vid(mov)
    fDat{1} = vidfile{mov};
    fDat{2}{1} = viddat{mov}{1};
    if isFullLengthVideo(vidfile{mov},h_fig)
        fDat{2}{2} = h.movie.movie;
    else
        fDat{2}{2} = [];
    end
    fDat{3} = viddat{mov}{2};
    fDat{4} = viddat{mov}{3};
    [o,data] = create_trace(newPnt,pxdim,npix,fDat);
    if isempty(data)
        return
    end
    
elseif h_axes0==h.axes_VP_avimg(mov)
    extr = floor(pxdim/2);
    lim_inf = ceil(newPnt)-extr;
    lim.Xinf = lim_inf(1,1);
    lim.Yinf = lim_inf(1,2);
    data = tracesFromMatrix(curr.res_plot{2}{mov},1,lim,pxdim,npix,false);
    nExc = 1;
end

str_sec = [];
if persec
    str_sec = ' /s';
    data = data/expT;
end

time_ax = expT*((1:size(data,1))');

ITT = cell(1,nExc);
for i = 1:nExc
    ITT{i}(:,1) = time_ax(i:nExc:end,1)*expT;
    ITT{i}(:,2) = data(i:nExc:end,1);
end

h_figBG_mov = figure('Color', [1 1 1], 'NumberTitle', 'off', ...
    'Name', cat(2,'Intensity-time trace at coordinates (',...
    num2str(newPnt(1)),',',num2str(newPnt(2)),')'), 'Visible', 'off');

posFig = get(h_figBG_mov, 'Position');
set(h_figBG_mov, 'Position', [posFig(1) posFig(2) 500 200]);
h_axes = axes('Units', 'pixels', 'OuterPosition', [0 0 500 200], ...
    'NextPlot', 'add');
clr = [0 0 1
    1 0 0
    0 1 0
    0 0 0];

leg_str = {};
for i = 1:nExc
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
ylabel(h_axes, {'intensity',['(counts' str_sec ')']});
if nExc>1
    legend(h_axes, leg_str);
end
grid on;

guidata(h_fig, h);

% display success
setContPan('Intensity-time traces were sucessfully generated!','success',...
    h_fig);

if ~fromRoutine
    set(h_figBG_mov,'visible','on');
    export = questdlg('Do you want to export these data to the workspace?', ...
        'Export time trace', 'Yes', 'No', 'Yes');
    if strcmp(export, 'Yes')
        export2wsdlg({'Intensity-time trace'}, {'variable name'}, {ITT});
    end
else
    print(h_figBG_mov,file_out,'-dpng');
    close(h_figBG_mov);
end

