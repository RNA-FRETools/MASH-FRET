function ud_TDPmdlSlct(h_fig)

%% collect parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;

exc = p.proj{proj}.excitations;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
labels = p.proj{proj}.labels;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

tpe = p.curr_type(proj);
prm = p.proj{proj}.prm{tpe};

meth = prm.clst_start{1}(1);
mode = prm.clst_start{1}(2);
Kmax = prm.clst_start{1}(3);
curr_k = prm.clst_start{1}(4);
N = prm.clst_start{1}(5);
boba = prm.clst_start{1}(6);
clr = prm.clst_start{3}(curr_k,:);
res = prm.clst_res;


%% build data type list
str_pop = {};
for l = 1:nExc
    for c = 1:nChan
        str_pop = [str_pop [labels{c} ' at ' num2str(exc(l)) 'nm']];
    end
end
for n = 1:nFRET
    str_pop = [str_pop ['FRET ' labels{FRET(n,1)} '>' labels{FRET(n,2)}]];
end
for n = 1:nS
    str_pop = [str_pop ['S ' labels{S(n)}]];
end


%% set general parameters
set([h.text_TDPdataType h.popupmenu_TDPdataType ...
    h.togglebutton_TDPkmean h.togglebutton_TDPgauss ...
    h.popupmenu_TDPstate h.text_TDPstate h.text_TDPnStates ...
    h.edit_TDPnStates h.text_TDPiter h.edit_TDPmaxiter ...
    h.pushbutton_TDPautoStart h.pushbutton_TDPresetClust ...
    h.pushbutton_TDPupdateClust h.text_TDPradius h.edit_TDPradius ...
    h.checkbox_TDPboba], 'Enable', 'on', 'Visible', 'on');

set([h.edit_TDPnStates h.edit_TDPiniVal h.edit_TDPradius ...
    h.edit_TDPmaxiter h.listbox_TDPtrans], 'BackgroundColor', [1 1 1]);

set(h.popupmenu_TDPdataType, 'Value', tpe, 'String', str_pop);
set(h.edit_TDPnStates, 'String', num2str(Kmax));

[id_clr,o,o] = find(p.colList(:,1)==clr(1) & p.colList(:,2)==clr(2) & ...
    p.colList(:,3)==clr(3));
if ~isempty(id_clr)
    set(h.popupmenu_TDPcolour, 'Value', id_clr(1), 'Enable', 'on');
end
set(h.edit_TDPcolour, 'Enable', 'inactive', 'BackgroundColor', clr);


%% set starting parameters
if meth == 1 % kmean clustering
    state = get(h.popupmenu_TDPstate, 'Value');
    if state > Kmax
        state = Kmax;
    end
    trs_k = prm.clst_start{2}(state,:);
    
    set(h.text_TDPstate, 'String', 'state n°:');
    
    str_pop = cellstr(num2str((1:Kmax)'));
    set(h.popupmenu_TDPstate, 'Value', state, 'String', str_pop, ...
        'TooltipString', 'current state');
    
    set(h.togglebutton_TDPkmean, 'Value', 1, 'FontWeight', 'bold');
    set(h.togglebutton_TDPgauss, 'Value', 0, 'FontWeight', 'normal');

    set([h.text_TDPstate h.popupmenu_TDPstate h.text_TDPiniVal ...
        h.edit_TDPiniVal], 'Enable', 'on');
    
    set(h.text_TDPstate, 'String', 'state:');
    set(h.text_TDPiter, 'String', 'iter nb.:');
    set(h.text_TDPiniVal, 'String', 'value');
%     set(h.text_TDPradius, 'String', sprintf('  \nradius'));
    set(h.text_TDPradius, 'String', 'radius');
    set(h.edit_TDPiniVal, 'String', num2str(trs_k(1)));
    set(h.edit_TDPradius, 'String', num2str(trs_k(2)), 'TooltipString', ...
        'Radius of the tolerance area around centers');
    
    set(h.edit_TDPmaxiter, 'String', num2str(N), 'TooltipString', ...
        'Max. number of kmean iterations');
    
else % GMM-based clustering
    
    set(h.togglebutton_TDPkmean, 'Value', 0, 'FontWeight', 'normal');
    set(h.togglebutton_TDPgauss, 'Value', 1, 'FontWeight', 'bold');
    
    set (h.text_TDPstate, 'String', 'cluster shape');
    
    str_pop = {'spherical','ellipsoid straight','ellipsoid diagonal', ...
        'free'};
    set(h.popupmenu_TDPstate, 'Value', mode, 'String', str_pop, ...
        'TooltipString', '2D Gaussian symetry');
    
    set([h.text_TDPiniVal h.edit_TDPiniVal], 'String', '', 'Enable', ...
        'off');
    
%     set(h.text_TDPradius, 'String', sprintf('max.\nsigma'));
%     set(h.edit_TDPradius, 'String', num2str(prm.clst_start{2}(1,2)), ...
%         'TooltipString', ...
%         'Max. standard deviation of the 2D Gaussian distributions');
    set([h.text_TDPradius h.edit_TDPradius], 'String', '', 'Enable', ...
        'off');
    
    set(h.text_TDPiter, 'String', 'restarts:');
    set(h.edit_TDPmaxiter, 'String', num2str(N), 'TooltipString', ...
        'Number of Gaussian mixture initialisations.');
end

if boba
    nSpl = prm.clst_start{1}(7);
    nRpl = prm.clst_start{1}(8);
    set([h.edit_TDPnRepl h.text_TDPnRepl h.edit_TDPnSpl ...
        h.text_TDPnSpl], 'Enable', 'on');
    set([h.edit_TDPnSpl h.edit_TDPnSpl], 'BackgroundColor', [1 1 1]);
    set(h.edit_TDPnSpl, 'String', num2str(nSpl));
    set(h.edit_TDPnRepl, 'String', num2str(nRpl));
else
    set([h.edit_TDPnRepl h.text_TDPnRepl h.edit_TDPnSpl ...
        h.text_TDPnSpl], 'Enable', 'off');
    set([h.edit_TDPnSpl h.edit_TDPnSpl], 'String', '');
end
set(h.checkbox_TDPboba, 'Value', boba);


%% set results
if isempty(res{1})
    
    % build transition list
    str_list = {};
    for k1 = 1:Kmax
        for k2 = 1:Kmax
            if k1 ~= k2
                vals = round(100*prm.clst_start{2}([k1 k2],1))/100;
                str_list = [str_list strcat(num2str(vals(1)), ' to ', ...
                    num2str(vals(2)))];
            end
        end
    end
    if isempty(str_list) || meth == 2 %GM
        str_list = {''};
        curr_k = 1;
    end
    set(h.listbox_TDPtrans, 'String', str_list, 'Value', curr_k, ...
        'Enable', 'on');
    set([h.edit_TDPbobaRes h.edit_TDPbobaSig h.text_TDPbobaRes ...
        h.text_TDPbobaSig], 'Enable', 'off');
    set([h.edit_TDPbobaRes h.edit_TDPbobaSig], 'String', '');

else
    Kopt = size(res{1},1);
    if Kopt*(Kopt-1) <= 0
        curr_k = 1;
    elseif curr_k > Kopt*(Kopt-1)
        curr_k = Kopt*(Kopt-1);
    end
    
    % build transition list
    str_list = {};
    k = 0;
    for k1 = 1:Kopt
        for k2 = 1:Kopt
            if k1 ~= k2
                k = k+1;
                vals = round(100*res{1}([k1 k2],1))/100;
                str_list = [str_list strcat(num2str(vals(1)), ' to ', ...
                    num2str(vals(2)))];
            end
        end
    end
    if isempty(str_list)
        str_list = {''};
    end
    set(h.listbox_TDPtrans, 'String', str_list, 'Value', curr_k, ...
        'Enable', 'on');
    
    if boba
        set([h.text_TDPbobaRes h.text_TDPbobaSig], 'Enable', 'on');
        set([h.edit_TDPbobaRes h.edit_TDPbobaSig], 'Enable', 'inactive');
        if ~isempty(res{3}.boba_K)
            set(h.edit_TDPbobaRes, 'String', num2str(res{3}.boba_K(1)));
            set(h.edit_TDPbobaSig, 'String', num2str(res{3}.boba_K(2)));
        end
    else
        set([h.edit_TDPbobaRes h.edit_TDPbobaSig h.text_TDPbobaRes ...
            h.text_TDPbobaSig], 'Enable', 'off');
        set([h.edit_TDPbobaRes h.edit_TDPbobaSig], 'String', '');
    end
end



