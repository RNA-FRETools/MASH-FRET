function popupmenu_selectData_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

ind = get(h.tm.popupmenu_selectData,'Value');
j = get(h.tm.popupmenu_selectCalc,'value');

% control the presence of discretized data
if j==6
    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    
    str_axes = 'bottom';
    
    n = 0;
    if ind<=nChan*nExc
        for l = 1:nExc
            for c = 1:nChan
                n = n+1;
                if n==ind
                    break;
                end
            end
        end
        discr = p.proj{proj}.intensities_DTA(:,c:nChan:end,l);
        
        str_axes = 'top';
        
    elseif ind<=(nChan*nExc+nFRET)
        n = ind-nChan*nExc;
        discr = p.proj{proj}.FRET_DTA(:,n:nFRET:end);
        
    elseif ind<=(nChan*nExc+nFRET+nS)
        n = ind-(nChan*nExc+nFRET);
        discr = p.proj{proj}.S_DTA(:,n:nS:end);
        
    else
        n = 0;
        for fret = 1:nFRET
            for s = 1:nS
                n = n+1;
                if n==(ind+nChan*nExc+nFRET+nS)
                    break;
                end
            end
        end
        discr = cat(3,p.proj{proj}.FRET_DTA(:,fret:nFRET:end),...
            p.proj{proj}.S_DTA(:,s:nS:end));
    end
    
    isdiscr = ~all(isnan(sum(sum(discr,3),2)));
    if ~isdiscr
        str = cat(2,'This method requires the individual time-traces in ',...
            str_axes,' axes to be discretized: please return to Trace ',...
            'processing and infer the corresponding state trajectories.');
        setContPan(str,'error',h_fig);
        set(obj,'value',get(obj,'userdata'));
            return;
    end
end

set(obj,'userdata',get(obj,'value'));

plotData_autoSort(h_fig);
ud_panRanges(h_fig);

