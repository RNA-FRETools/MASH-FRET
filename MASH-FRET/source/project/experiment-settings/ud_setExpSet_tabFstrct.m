function ud_setExpSet_tabFstrct(h_fig)

% defaults
grayfnt = round([0.75,0.75,0.75]*256);

% retrieve interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct))
    return
end

% retrieve project parameters
proj = h_fig.UserData;
% nChan = proj.nb_channel;
exc = proj.excitations;
% clr = proj.colours;
FRET = proj.FRET;
opt = proj.traj_import_opt;
isfiles = ~isempty(h.table_fstrct.UserData);

nExc = numel(exc);
isalex = nExc>1;
nPair = size(FRET,1);
ispair = nPair>0;
hline = opt{1}{1}(1); % old first intensity line
delim = opt{1}{1}(2); % old last intensity line
istdat = opt{1}{1}(3);
tcol = opt{1}{1}(4);
icol1 = opt{1}{1}(5);
icol2 = opt{1}{1}(6);
rowwise = opt{1}{1}(7); % old nb. of channels
tcol_exc = opt{1}{2}; % old laser wavelength
icolexc = opt{1}{3};
isfretdat = opt{1}{1}(9);
fretcol1 = opt{1}{1}(10);
fretcol2 = opt{1}{1}(11);
skipfretcol = opt{1}{1}(12);

% set header lines
set(h.edit_hLines,'string',num2str(hline));

% set column delimiter
set(h.pop_delim,'value',delim);

% set ALEX file structure
if isalex
    set([h.text_alexDat,h.pop_alexDat],'visible','on');
    set(h.pop_alexDat,'value',rowwise);
else
    set([h.text_alexDat,h.pop_alexDat],'visible','off');
end

% set intensity data
if rowwise==1 || ~isalex
    set([h.text_intFrom,h.edit_intFrom,h.text_intTo,h.edit_intTo,...
        h.text_intZero],'visible','on');
    set([h.text_intExcCol,h.edit_intExcCol1,h.text_intExcTo,...
        h.edit_intExcCol2,h.text_intExcZero],'visible','off');
    set(h.edit_intFrom,'string',num2str(icol1));
    set(h.edit_intTo,'string',num2str(icol2));
else
    set([h.text_intFrom,h.edit_intFrom,h.text_intTo,h.edit_intTo,...
        h.text_intZero],'visible','off');
    set([h.text_intExcCol,h.edit_intExcCol1,h.text_intExcTo,...
        h.edit_intExcCol2,h.text_intExcZero],'visible','on');
    for l = 1:nExc
        set(h.edit_intExcCol1(l),'string',num2str(icolexc(l,1)));
        set(h.edit_intExcCol2(l),'string',num2str(icolexc(l,2)));
    end
end

% set time data
set(h.check_timeDat,'value',istdat);
if rowwise==1 || ~isalex
    set([h.text_timeExcCol,h.edit_timeExcCol,h.text_timeExcZero],...
        'visible','off');
    set([h.edit_timeCol,h.text_timeZero],'visible','on');
    if ~istdat
        set([h.edit_timeCol,h.text_timeZero],'enable','off');
    else
        set([h.edit_timeCol,h.text_timeZero],'enable','on');
        set(h.edit_timeCol,'string',num2str(tcol));
    end
else
    set([h.text_timeExcCol,h.edit_timeExcCol,h.text_timeExcZero],...
        'visible','on');
    set([h.edit_timeCol,h.text_timeZero],'visible','off');
    if ~istdat
        set([h.text_timeExcCol,h.edit_timeExcCol,h.text_timeExcZero],...
            'enable','off');
    else
        set([h.text_timeExcCol,h.edit_timeExcCol,h.text_timeExcZero],...
            'enable','on');
        for l = 1:nExc
            set(h.edit_timeExcCol(l),'string',num2str(tcol_exc(l)));
        end
    end
end

% set FRET sequence data
if ispair
    set([h.check_FRETseq,h.text_FRETseqFrom,h.edit_FRETseqCol1,...
        h.text_FRETseqTo,h.edit_FRETseqCol2,h.text_FRETseqZero,...
        h.text_FRETseqSkip,h.edit_FRETseqSkip],'visible','on');
    set(h.check_FRETseq,'value',isfretdat);
    set(h.edit_FRETseqCol1,'string',num2str(fretcol1));
    set(h.edit_FRETseqCol2,'string',num2str(fretcol2));
    set(h.edit_FRETseqSkip,'string',num2str(skipfretcol));
    if isfretdat
        set([h.text_FRETseqFrom,h.edit_FRETseqCol1,h.text_FRETseqTo,...
            h.edit_FRETseqCol2,h.text_FRETseqZero,h.text_FRETseqSkip,...
            h.edit_FRETseqSkip],'enable','on');
    else
        set([h.text_FRETseqFrom,h.edit_FRETseqCol1,h.text_FRETseqTo,...
            h.edit_FRETseqCol2,h.text_FRETseqZero,h.text_FRETseqSkip,...
            h.edit_FRETseqSkip],'enable','off');
    end
else
    set([h.check_FRETseq,h.text_FRETseqFrom,h.edit_FRETseqCol1,...
        h.text_FRETseqTo,h.edit_FRETseqCol2,h.text_FRETseqZero,...
        h.text_FRETseqSkip,h.edit_FRETseqSkip],'visible','off');
end

% set preview table
if isfiles 
    
    % read data from first file
    fdat = h.table_fstrct.UserData;
    
    % color header
    tbldat = fdat;
    [R,C] = size(fdat);
    for r = 1:hline
        for c = 1:C
            tbldat{r,c} = getHtmlColorStr(fdat{r,c},grayfnt,'normal');
        end
    end
    
    % color intensity columns
    switch rowwise
        case 1
            if icol1>0 && icol2==0
                icol2 = C;
            end
        %     l = 0;
            for r = (hline+1):R
        %         l = l+1;
        %         if l>nExc
        %             l = 1;
        %         end
        %         chan = 0;
                for c = icol1:icol2
        %             chan = chan+1;
        %             if chan>nChan
        %                 chan = 1;
        %             end
        %             tbldat{r,c} = getHtmlColorStr(fdat{r,c},clr{1}{l,chan},'bold');
                    if c==0
                        continue
                    end
                    tbldat{r,c} = getHtmlColorStr(fdat{r,c},...
                        h.text_intDat.ForegroundColor,'bold');
                end
            end
            
        case 2
            for l = 1:nExc
                if icolexc(l,1)>0 && icolexc(l,2)==0
                    icolexc(l,2) = C;
                end
                for r = (hline+1):R
                    for c = icolexc(l,1):icolexc(l,2)
                        if c==0
                            continue
                        end
                        tbldat{r,c} = getHtmlColorStr(fdat{r,c},...
                            h.text_intDat.ForegroundColor,'bold');
                    end
                end
            end
    end
    
    % color time column
    if istdat
        switch rowwise
            case 1
                if tcol==0
                    tcol = C;
                end
                for r = (hline+1):R
                    tbldat{r,tcol} = getHtmlColorStr(fdat{r,tcol},...
                        h.check_timeDat.ForegroundColor,'bold');
                end
            case 2
                for l = 1:nExc
                    if tcol_exc(l)==0
                        tcol_exc(l) = C;
                    end
                    for r = (hline+1):R
                        tbldat{r,tcol_exc(l)} = ...
                            getHtmlColorStr(fdat{r,tcol_exc(l)},...
                            h.check_timeDat.ForegroundColor,'bold');
                    end
                end
        end
    end
    
    % color FRET sequence columns
    if ispair && isfretdat
        if fretcol1>0 && fretcol2==0
            fretcol2 = C;
        end
        for r = (hline+1):R
%             pair = 0;
            for c = fretcol1:(skipfretcol+1):fretcol2
                if c==0
                    continue
                end
%                 pair = pair+1;
%                 if pair>nPair
%                     pair = 1;
%                 end
%                 tbldat{r,c} = getHtmlColorStr(fdat{r,c},clr{2}(pair,:),'bold');
                tbldat{r,c} = getHtmlColorStr(fdat{r,c},...
                    h.check_FRETseq.ForegroundColor,'bold');
            end
        end
    end
    
    set(h.table_fstrct,'data',tbldat);
end

% set button
set(h.push_nextFstrct,'enable','on');
