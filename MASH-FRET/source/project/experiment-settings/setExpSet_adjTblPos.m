function setExpSet_adjTblPos(h_fig)

% defaults
wsld = 15; % sliding bar width
wbrd = 1; % width of table's border
hrow0 = 20; % table's header height
hrow = 18; % table's row height
maxrow = 2; % maximum number of rows in table before vertical sliding bar appears

% retrieve interface content
h = guidata(h_fig);

% get parent
h_tab = h.tab_fstrct;
h_but = h.push_nextFstrct;
h_cb = h.check_FRETseq;
h_txt = h.text_preview;

% get dimensions
postab = getPixPos(h_tab);
poscb = getPixPos(h_cb);
posbut = getPixPos(h_but);
postxt = getPixPos(h_txt);
ymin = posbut(2)+posbut(4)+h.mg;
ymax = poscb(2)-h.mg/2;
htot = ymax-ymin-h.mg-postxt(4)-h.mg/2;
wtbl2 = postab(3)-2*h.mg;

% get intensity table dimensions
wcol = cell2mat(h.tbl_intCol.ColumnWidth);
R = size(h.tbl_intCol.Data,1);
if R>maxrow
    wtbl0 = sum([wcol+wbrd,wsld]);
else
    wtbl0 = sum(wcol+wbrd);
end
hmax = h.tbl_intCol.UserData;
htbl0 = min([hmax,R*hrow+hrow0+2*wbrd]);

% get state sequence table dimensions
wcol = cell2mat(h.tbl_seqCol.ColumnWidth);
R = size(h.tbl_seqCol.Data,1);
if R>maxrow
    wtbl1 = sum([wcol+wbrd,wsld]);
else
    wtbl1 = sum(wcol+wbrd);
end
hmax = h.tbl_seqCol.UserData;
htbl1 = min([hmax,R*hrow+hrow0+2*wbrd]);

% get file preview table dimensions
htbl2 = htot-max([htbl0,htbl1]);

% adjust table positions
setPixPos(h.tbl_intCol,[h.mg,ymax-htbl0,wtbl0,htbl0]);
setPixPos(h.tbl_seqCol,[h.mg+wtbl0+h.mg,ymax-htbl1,wtbl1,htbl1]);
setPixPos(h.table_fstrct,[h.mg,ymin,wtbl2,htbl2]);

% adjust checkbox and text positions
setPixPos(h_cb,[h.mg+wtbl0+h.mg,poscb(2:end)]);
setPixPos(h_txt,[postxt(1),ymin+htbl2+h.mg/2,postxt(3:end)]);
