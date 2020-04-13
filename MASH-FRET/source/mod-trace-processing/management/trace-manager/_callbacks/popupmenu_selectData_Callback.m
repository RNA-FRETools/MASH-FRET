function popupmenu_selectData_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;

indx = get(h.tm.popupmenu_selectXdata,'Value');
indy = get(h.tm.popupmenu_selectYdata,'Value')-1;
jx = get(h.tm.popupmenu_selectXval,'value')-1;
jy = get(h.tm.popupmenu_selectYval,'value')-1;

is2D = indy>0;
needDiscr = sum(jx==[1,6:9]) || sum(jy==[1,6:9]);

% control the presence of discretized data
if needDiscr
    
    [isdiscr,str_axes] = controlDiscrForAS(indx,p.proj{proj});
    if is2D
        [isdiscr_y,str_axes_y] = controlDiscrForAS(indy,p.proj{proj});
        if ~isdiscr_y && ~isempty(str_axes)
            if ~strcmp(str_axes,str_axes_y)
               str_axes = cat(2,str_axes,' and ',str_axes_y);
            end
        elseif ~isdiscr_y
            str_axes = str_axes_y;
        end
        isdiscr = isdiscr | isdiscr_y;
    end
    
    if ~isdiscr
        str = cat(2,'This method requires the individual time-traces in ',...
            str_axes,' axes to be discretized: please return to Trace ',...
            'processing and infer the corresponding state trajectories.');
        setContPan(str,'error',h_fig);
        set(obj,'value',get(obj,'userdata'));
            return
    end
end

set(obj,'userdata',get(obj,'value'));

plotData_autoSort(h_fig);
ud_panRanges(h_fig);

