function ud_setExpSet_tabFstrct(h_fig)

% defaults
grayfnt = round([0.75,0.75,0.75]*256);
colname = {'data','from','to','skip'};

% retrieve interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct))
    return
end

% determine data to structure
istraj = isfield(h,'text_impTrajFiles') && ishandle(h.text_impTrajFiles);

% retrieve project parameters
proj = h_fig.UserData;
nChan = proj.nb_channel;
exc = proj.excitations;
lbl = proj.labels;
clr = proj.colours;
pairs = proj.FRET;
if istraj
    opt = proj.traj_import_opt;
else
    opt = proj.hist_import_opt;
end
isfiles = ~isempty(h.table_fstrct.UserData);

nExc = numel(exc);
isalex = nExc>1;
nPair = size(pairs,1);
ispair = nPair>0;

if istraj
    hline = opt{1}{1}(1); % old first intensity line
    delim = opt{1}{1}(2); % old last intensity line
    istdat = opt{1}{1}(3);
    tcol = opt{1}{1}(4);
    rowwise = opt{1}{1}(5); 
    isfretdat = opt{1}{1}(6);
    onemol = opt{1}{1}(7); % old nb. of channels
    tcol_exc = opt{1}{2};
    icol = opt{1}{3};
    icolexc = opt{1}{4};
    fretcol = opt{1}{5};
else
    hline = opt(1); 
    delim = opt(2);
    xcol = opt(3);
    pcol = opt(4);
end

% set header lines
set(h.edit_hLines,'string',num2str(hline));

% set column delimiter
set(h.pop_delim,'value',delim);

if istraj
    % set sample
    switch onemol
        case 1
            set(h.pop_oneMol,'value',1);
        case 0
            set(h.pop_oneMol,'value',2);
    end

    % set ALEX file structure
    if isalex
        set([h.text_alexDat,h.pop_alexDat],'enable','on');
        set(h.pop_alexDat,'value',rowwise);
    else
        set([h.text_alexDat,h.pop_alexDat],'enable','off');
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

    % set intensity data
    wdata = getUItextWidth(colname{1},h.fun,h.fsz,'normal',h.tbl); % get minimum width of "data" column

    if rowwise==1 || ~isalex
        int_dat = reshape(cellstr(num2str(icol(:))),[nChan,3]);

        % color cells of 1st column
        [~,l_min] = min(exc); % get greenest laser index
        int_lbl = cell(nChan,1);
        wlbl = wdata;
        for c = 1:nChan
            int_lbl{c} = getHtmlColorStr(lbl{c},clr{1}{l_min,c},'bold');
            wlbl = max([wlbl,getUItextWidth(lbl{c},h.fun,h.fsz,'bold',...
                h.tbl)]);
        end
        int_dat = cat(2,int_lbl,int_dat);

    elseif rowwise==2
        int_dat = {};
        int_lbl = cell(nChan*nExc,1);
        ind = 0;
        wlbl = wdata;
        for l = 1:nExc
            int_dat = cat(1,int_dat,reshape(cellstr(num2str(reshape(...
                icolexc(:,:,l),[],1))),[nChan,3]));
            for c = 1:nChan
                ind = ind+1;
                int_lbl{ind} = [lbl{c},',',num2str(exc(l)),'nm'];
                wlbl = max([wlbl,getUItextWidth(int_lbl{ind},h.fun,h.fsz,...
                    'bold',h.tbl)]);
            end
        end

        % color cells of 1st column
        for l = 1:nExc
            for c = 1:nChan
                int_lbl{nChan*(l-1)+c} = ...
                    getHtmlColorStr(int_lbl{nChan*(l-1)+c},clr{1}{l,c},...
                    'bold');
            end
        end
        int_dat = cat(2,int_lbl,int_dat);
    end

    % adjust enability of "to" and "skip" columns
    R = size(int_dat,1);
    if onemol
        set(h.tbl_intCol,'columneditable',[false,true,false,false]);
        for r = 1:R
            for c = 3:4
                int_dat{r,c} = getHtmlColorStr(int_dat{r,c},grayfnt,...
                    'normal');
            end
        end
    else
        set(h.tbl_intCol,'columneditable',[false,true,true,true]);
    end

    % update intensity table
    set(h.tbl_intCol,'data',int_dat,'columnname',colname,'rowname',[],...
        'columnwidth',[wlbl,h.tbl_intCol.ColumnWidth(2:end)]);

    % set FRET sequence data
    if ~ispair
        set([h.check_FRETseq,h.tbl_seqCol],'enable','off','visible','off');
    else
        set([h.check_FRETseq,h.tbl_seqCol],'enable','on','visible','on');
        set(h.check_FRETseq,'value',isfretdat);
        seq_dat = reshape(cellstr(num2str(fretcol(:))),[nPair,3]);
        seq_lbl = cell(nPair,1);
        wlbl = wdata;
        for pair = 1:nPair
            pair_lbl = ['FRET',num2str(pairs(pair,1)),...
                num2str(pairs(pair,2))];
            seq_lbl{pair} = getHtmlColorStr(pair_lbl,clr{2}(pair,:),...
                'bold');
            wlbl = max([wlbl,...
                getUItextWidth(pair_lbl,h.fun,h.fsz,'bold',h.tbl)]);
        end
        seq_dat = cat(2,seq_lbl,seq_dat);
        wcol = [wlbl,h.tbl_seqCol.ColumnWidth{2:end}];

        % adjust enability of "to" and "skip" columns
        R = size(seq_dat,1);
        if onemol
            set(h.tbl_seqCol,'columneditable',[false,true,false,false]);
            for r = 1:R
                for c = 3:4
                    seq_dat{r,c} = ...
                        getHtmlColorStr(seq_dat{r,c},grayfnt,'normal');
                end
            end
        else
            set(h.tbl_seqCol,'columneditable',[false,true,true,true]);
        end

        % update table
        set(h.tbl_seqCol,'data',seq_dat,'columnname',colname,'rowname',[],...
            'columnwidth',num2cell(wcol));

        if ~isfretdat
            set(h.tbl_seqCol,'enable','off');
        end
    end
    
else
    % set histogram x-value column
    set([h.edit_xval,h.text_xval],'enable','on');
    set(h.edit_xval,'string',num2str(xcol));
    
    % set histogram count-value column
    set([h.edit_countval,h.text_countval],'enable','on');
    set(h.edit_countval,'string',num2str(pcol));
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
    if istraj
        switch rowwise
            case 1
                icol(icol(:,1)==0,1) = C;
                icol(icol(:,2)==0,2) = C;
                for chan = 1:nChan
                    icol_chan = icol(chan,1):(icol(chan,3)+1):icol(chan,2);
                    if onemol
                        icol_chan = icol_chan(1);
                    end
                    for c = icol_chan
                        l = 0;
                        for r = (hline+1):R
                            l = l+1;
                            if l>nExc
                                l = 1;
                            end
                            tbldat{r,c} = getHtmlColorStr(fdat{r,c},...
                                clr{1}{l,chan},'bold');
                        end
                    end
                end

            case 2
                for l = 1:nExc
                    icolexc(icolexc(:,1,l)==0,1,l) = C;
                    icolexc(icolexc(:,2,l)==0,2,l) = C;
                    for chan = 1:nChan
                        icol_chan = icolexc(chan,1,l):...
                            (icolexc(chan,3,l)+1):icolexc(chan,2,l);
                        if onemol
                            icol_chan = icol_chan(1);
                        end
                        for c = icol_chan
                            for r = (hline+1):R
                                tbldat{r,c} = getHtmlColorStr(fdat{r,c},...
                                    clr{1}{l,chan},'bold');
                            end
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
            fretcol(fretcol(:,1)==0,1) = C;
            fretcol(fretcol(:,2)==0,2) = C;
            for pair = 1:nPair
                icol_pair = ...
                    fretcol(pair,1):(fretcol(pair,3)+1):fretcol(pair,2);
                if onemol
                    icol_pair = icol_pair(1);
                end
                for c = icol_pair
                    for r = (hline+1):R
                        tbldat{r,c} = getHtmlColorStr(fdat{r,c},...
                            clr{2}(pair,:),'bold');
                    end
                end
            end
        end
        
    else
        % color histogram bin column
        for r = (hline+1):R
            tbldat{r,xcol} = getHtmlColorStr(fdat{r,xcol},...
                h.edit_xval.ForegroundColor,'bold');

            % color histogram count column
            tbldat{r,pcol} = getHtmlColorStr(fdat{r,pcol},...
                h.edit_countval.ForegroundColor,'bold');
        end
    end
    
    set(h.table_fstrct,'data',tbldat);
end

if istraj
    setExpSet_adjTblPos(h_fig);
end

% set button
set(h.push_nextFstrct,'enable','on');
