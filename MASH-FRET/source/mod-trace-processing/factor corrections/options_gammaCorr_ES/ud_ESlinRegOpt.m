function ud_ESlinRegOpt(h_fig,h_fig2)

h = guidata(h_fig);
q = guidata(h_fig2);

p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
fact = p.proj{proj}.curr{mol}{6}{1};
prm = q.prm{2};
gamma = q.prm{1}(1,1);
beta = q.prm{1}(2,1);

% get current FRET pair
fret = p.proj{proj}.fix{3}(8);

% set subgroup list
str_tag = getStrPopTags(p.proj{proj}.molTagNames,p.proj{proj}.molTagClr);
nTag = size(str_tag,2);
if nTag>1
    str_tag = cat(2,'All molecules',str_tag);
end
if prm(fret,1)>size(str_tag,2)
    prm(fret,1) = 1;
end
set(q.popupmenu_tag,'string',str_tag,'value',prm(fret,1));

% set processing parameters
set([q.edit_Emin,q.edit_Ebin,q.edit_Emax,q.edit_Smin,q.edit_Sbin,...
    q.edit_Smax],'backgroundcolor',[1,1,1]);
set(q.edit_Emin,'string',num2str(prm(fret,2)));
set(q.edit_Emax,'string',num2str(prm(fret,3)));
set(q.edit_Ebin,'string',num2str(prm(fret,4)));
set(q.edit_Smin,'string',num2str(prm(fret,5)));
set(q.edit_Smax,'string',num2str(prm(fret,6)));
set(q.edit_Sbin,'string',num2str(prm(fret,7)));

% set results
set(q.edit_gamma,'string',num2str(gamma));
set(q.edit_beta,'string',num2str(beta));
set(q.checkbox_show,'value',q.prm{3});

% plot ES histogram
if ~q.prm{3}
    plot_ESlinRegOpt(q.axes_ES,q.prm{4}{fret},prm(fret,:),q.prm{1});
else
    if isempty(q.prm{5})
        fact(:,fret) = q.prm{1};
        [ES,ok,str] = getES(fret,p.proj{proj},prm,fact,h_fig);
        if ~ok
            setContPan(str,'warning',h_fig);
        end
        q.prm{5} = ES;
    end
    plot_ESlinRegOpt(q.axes_ES,q.prm{5},prm(fret,:),[1;1]);
end

% save changes
q.prm{2} = prm;
guidata(h_fig2,q);


