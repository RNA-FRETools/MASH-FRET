function set_VP_expOpt(opt,h_fig)
% set_VP_expOpt(opt,h_fig)
%
% Set export options to proper values
%
% opt: export options (ascii all,ascii one,hammy,vbfret,qub,smart,ebfret)
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
q = h.itgFileOpt;

% set export otpions
set(q.checkbox_ASCII, 'Value', opt(1)|opt(2));
checkbox_FileASCII_Callback(h.checkbox_FileASCII,[],h_fig);

if opt(1) || opt(2)
    set(q.checkbox_allMol, 'Value',opt(1));
    set(q.checkbox_oneMol, 'Value',opt(2));
end
set(q.checkbox_HaMMy, 'Value',opt(3));
set(q.checkbox_vbFRET, 'Value',opt(4));
set(q.checkbox_QUB, 'Value',opt(5));
set(q.checkbox_SMART, 'Value',opt(6));
set(q.checkbox_ebFRET, 'Value',opt(7));

