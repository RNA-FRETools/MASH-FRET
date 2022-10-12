function routinetest_setExpSet_fstrct(h_fig0,p)
% routinetest_setExpSet_fstrct(h_fig0,p)
%
% Set tab "File structure" of experiment settings to proper values 
%
% h_fig0: handle to main figure
% p: structure containing default as set by getDefault_VP

h0 = guidata(h_fig0);
h_fig = h0.figure_setExpSet;
h = guidata(h_fig);

prm = p.es{p.nChan,p.nL}.fstrct;

% set number of header lines
set(h.edit_hLines,'string',num2str(prm{1}(1)));
edit_setExpSet_hLines(h.edit_hLines,[],h_fig);

% set delimiter
set(h.pop_delim,'value',prm{1}(2));
pop_setExpSet_delim(h.pop_delim,[],h_fig);

% set sample
switch prm{1}(7)
    case 1
        set(h.pop_oneMol,'value',1);
        pop_setExpSet_oneMol(h.pop_oneMol,[],h_fig);
    case 2
        set(h.pop_oneMol,'value',2);
        pop_setExpSet_oneMol(h.pop_oneMol,[],h_fig);
end

% set ALEX data structure
set(h.pop_alexDat,'value',prm{1}(5));
pop_setExpSet_alexDat(h.pop_alexDat,[],h_fig);

% set time columns
set(h.check_timeDat,'value',prm{1}(3));
check_setExpSet_timeDat(h.check_timeDat,[],h_fig);
if prm{1}(3)
    if p.nL==1 || (p.nL>1 && prm{1}(5)==1)
        set(h.edit_timeCol,'string',num2str(prm{1}(4)));
        edit_setExpSet_timeCol(h.edit_timeCol,[],h_fig);
    elseif p.nL>1 && prm{1}(5)==2
        for l = 1:p.nL
            set(h.edit_timeExcCol(l),'string',num2str(prm{2}(l)));
            edit_setExpSet_timeExcCol(h.edit_timeExcCol(l),[],l,h_fig);
        end
    end
end

% set intensity columns
if p.nL==1 || (p.nL>1 && prm{1}(5)==1)
    for c = 1:size(prm{3},1)
        for n = 1:size(prm{3},2)
            evd.EditData = num2str(prm{3}(c,n));
            evd.Indices = [c,n+1];
            tbl_intCol_CellEdit(h.tbl_intCol,evd,h_fig);
            if prm{1}(7) && n==1
                break
            end
        end
    end
elseif p.nL>1 && prm{1}(5)==2
    r = 0;
    for l = 1:size(prm{4},3)
        for c = 1:size(prm{4},1)
            r = r+1;
            for n = 1:size(prm{4},2)
                evd.EditData = num2str(prm{4}(c,n,l));
                evd.Indices = [r,n+1];
                tbl_intCol_CellEdit(h.tbl_intCol,evd,h_fig);
                if prm{1}(7) && n==1
                    break
                end
            end
        end
    end
end

% set state trajectory columns
if size(p.es{p.nChan,p.nL}.calc.fret,1)>0
    set(h.check_FRETseq,'value',prm{1}(6));
    check_setExpSet_FRETseq(h.check_FRETseq,[],h_fig);
    if prm{1}(6)
        for pair = 1:size(prm{5},1)
            for n = 1:size(prm{5},2)
                evd.EditData = num2str(prm{5}(pair,n));
                evd.Indices = [pair,n+1];
                tbl_seqCol_CellEdit(h.tbl_seqCol,evd,h_fig);
                if prm{1}(7) && n==1
                    break
                end
            end
        end
    end
end


