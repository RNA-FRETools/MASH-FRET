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

% set ALEX data structure
set(h.pop_alexDat,'value',prm{1}(3));
pop_setExpSet_alexDat(h.pop_alexDat,[],h_fig);

% set intensity columns
if p.nL==1 || (p.nL>1 && prm{1}(3)==1)
    set(h.edit_intFrom,'string',num2str(prm{1}(4)));
    edit_setExpSet_intFrom(h.edit_intFrom,[],h_fig);

    set(h.edit_intTo,'string',num2str(prm{1}(5)));
    edit_setExpSet_intTo(h.edit_intTo,[],h_fig);
elseif p.nL>1 && prm{1}(3)==2
    for l = 1:p.nL
        set(h.edit_intExcCol1(l),'string',num2str(prm{3}(l,1)));
        edit_setExpSet_intExcCol1(h.edit_intExcCol1(l),[],l,h_fig);

        set(h.edit_intExcCol2(l),'string',num2str(prm{3}(l,2)));
        edit_setExpSet_intExcCol2(h.edit_intExcCol2(l),[],l,h_fig);
    end
end

% set time columns
set(h.check_timeDat,'value',prm{1}(6));
check_setExpSet_timeDat(h.check_timeDat,[],h_fig);

if p.nL==1 || (p.nL>1 && prm{1}(3)==1)
    set(h.edit_timeCol,'string',num2str(prm{1}(7)));
    edit_setExpSet_timeCol(h.edit_timeCol,[],h_fig);
elseif p.nL>1 && prm{1}(3)==2
    for l = 1:p.nL
        set(h.edit_timeExcCol(l),'string',num2str(prm{2}(l)));
        edit_setExpSet_timeExcCol(h.edit_timeExcCol(l),[],l,h_fig);
    end
end

% set state trajectory columns
if size(p.es{p.nChan,p.nL}.calc.fret,1)>0
    set(h.check_FRETseq,'value',prm{1}(8));
    check_setExpSet_FRETseq(h.check_FRETseq,[],h_fig);

    set(h.edit_FRETseqCol1,'string',num2str(prm{1}(9)));
    edit_setExpSet_FRETseqCol1(h.edit_FRETseqCol1,[],h_fig);

    set(h.edit_FRETseqCol2,'string',num2str(prm{1}(10)));
    edit_setExpSet_FRETseqCol2(h.edit_FRETseqCol2,[],h_fig);

    set(h.edit_FRETseqSkip,'string',num2str(prm{1}(11)));
    edit_setExpSet_FRETseqSkip(h.edit_FRETseqSkip,[],h_fig);
end


