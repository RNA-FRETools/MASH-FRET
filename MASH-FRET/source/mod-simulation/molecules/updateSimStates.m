function updateSimStates(h_fig)
% updateSimStates(h_fig)
%
% Adjust parameters state values and value deviations to the actual number of states
%
% h_fig: handle to main figure

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
curr = p.proj{proj}.sim.curr;
def = p.proj{proj}.sim.def;

% collect simulation parameters
J = curr.gen_dt{1}(3);
stateDat = curr.gen_dat{2};

if size(stateDat,2)==J
    return
end

% adjust FRET values and broadening
for i = 1:J
    if i > size(stateDat,2)
        stateDat = cat(2,stateDat,stateDat(:,i-1));
    end
end
curr.gen_dat{2} = stateDat(:,1:J);

% reset simulation results
curr.res_dt = def.res_dt;
curr.res_dat = def.res_dat;

% save modifications
p.proj{proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);


