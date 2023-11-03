function edit_plot_minint_Callback(obj,evd,h_fig)

% defaults
red = [1 0.75 0.75];

% get "lower intensity" value
minI = str2double(obj.String);

% retrieve project data
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
maxI = p.proj{proj}.TP.fix{2}(5);

% check for proper format
if ~(numel(minI)==1 && ~isnan(minI))
    set(obj,'backgroundcolor',red);
    setContPan('Lower intensity must be a number.','error',h_fig);
    return
    
elseif minI>=maxI
    setContPan(['Lower intensity can not be higher than the upper limit (',...
        num2str(maxI),').'],'warning',h_fig);
    minI = maxI-10;
end

% modify parameter "lower intensity"
p.proj{proj}.TP.fix{2}(4) = minI;

% save modification to project data
h.param = p;
guidata(h_fig,h);

% update interface
updateFields(h_fig,'ttPr');
