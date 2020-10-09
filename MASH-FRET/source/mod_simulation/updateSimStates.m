function updateSimStates(h_fig)
% updateSimStates(h_fig)
%
% Adjust parameters state values and value deviations to the actual number of states
%
% h_fig: handle to main figure

h = guidata(h_fig);
p = h.param.sim;

if size(p.stateVal,2)==p.nbStates
    return
end

for i = 1:p.nbStates
    if i > size(p.stateVal,2)
        p.stateVal(i) = p.stateVal(i-1);
        p.FRETw(i) = p.FRETw(i-1);
    end
end
p.stateVal = p.stateVal(1:p.nbStates);
p.FRETw = p.FRETw(1:p.nbStates);

if isfield(h,'results') && isfield(h.results,'sim')
    h.results = rmfield(h.results,'sim');
end

h.param.sim = p;
guidata(h_fig, h);


