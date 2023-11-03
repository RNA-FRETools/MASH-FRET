function edit_plot_maxint_Callback(obj,evd,h_fig)

% defaults
red = [1 0.75 0.75];

% get "lower intensity" value
maxI = str2double(obj.String);

% retrieve project data
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
minI = p.proj{proj}.TP.fix{2}(4);

% check for proper format
if ~(numel(maxI)==1 && ~isnan(maxI))
    set(obj,'backgroundcolor',red);
    setContPan('Upper intensity must be a number.','error',h_fig);
    return
    
elseif maxI<=minI
    setContPan(['Upper intensity can not be smaller than the lower limit ',...
        '(',num2str(minI),').'],'warning',h_fig);
    maxI = minI+10;
end

% modify parameter "lower intensity"
p.proj{proj}.TP.fix{2}(5) = maxI;

% save modification to project data
h.param = p;
guidata(h_fig,h);

% update interface
updateFields(h_fig,'ttPr');
