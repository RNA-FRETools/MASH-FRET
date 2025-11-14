function chld = drawtransscheme(haxes,states,tp,p)

% defaults
darr = 0.03; % space between arrows
strnull = ['< \it',char(949),'']; % neglectable transition prob
axclr = [0,0,0];
rmin = 0.07;
rmax = 0.5;

% collects draw parameters
J = numel(states);
clr = adjustParam('clr',repmat(axclr,J,1),p);
eps = adjustParam('eps',0,p);
theta0 = adjustParam('theta0',90,p);
useletter = adjustParam('useletter',false,p);
signb = adjustParam('signb',3,p);
addtxt = adjustParam('addtxt',true,p);
fntsz = adjustParam('fntsz',8,p);
fntszprob = adjustParam('fntszprob',1,p);
insec = adjustParam('insec',false,p);
hdlgth = adjustParam('hdlgth',2,p); % arrow head length in points
r = adjustParam('radius',repmat((1/3)*pi/(2*J),1,J),p);

% sets figure's units to pixels
hpar = getparent(haxes);
parun = setparentun2norm(haxes);

% collect state values
stateval = unique(states);
V = numel(stateval);

% determine state degeneracies
D = zeros(1,V);
for v = 1:V
    D(v) = sum(states==stateval(v));
end
J = sum(D);
statestr = cell(1,J);
fclr = zeros(J,3);
tclr = zeros(J,3);
for j = 1:J
    if iscell(useletter)
        % use input state labels
        v = find(stateval==states(j));
        jv = find(states==stateval(v));
        nb = find(jv==j);
        if isscalar(jv)
            % do not add nb if only one state in agglomerate
            statestr{j} = useletter{v};
        else
            % add degenerate index is more than one state in agglomerate
            statestr{j} = [useletter{v},num2str(nb)];
        end
    elseif useletter
        % use degenerate state index as state label
        statestr{j} = char(96+find(stateval==states(j)));
    else
        % use state index as state label
        statestr{j} = num2str(round(10*states(j))/10);
    end
    fclr(j,:) = clr(stateval==states(j),:);
    if all(fclr(j,:)<1)
        tclr(j,:) = [1,1,1];
    else
        tclr(j,:) = [0,0,0];
    end
end

% draw circles
chld = [];
if min(r)<rmin || max(r)>rmax
    if max(r)==min(r)
        r(r<rmin) = rmin;
        r(r>rmax) = rmax;
    else
        r = rmin+((r-min(r))/(max(r)-min(r)))*(rmax-rmin);
    end
end
for j = 1:J
    [x,y] = posoncircle(j,J,theta0);
    chld = cat(2,chld,rectangle(haxes,'position',[x-r(j),y-r(j),2*r(j),2*r(j)],...
        'curvature',[1,1],'edgecolor',axclr,'facecolor',fclr(j,:)));
    chld = cat(2,chld,text(haxes,x,y,statestr{j},'horizontalalignment','center',...
        'verticalalignment','middle','fontsize',fntsz,'fontweight','bold',...
        'color',tclr(j,:)));
end
xlim(haxes,[-max(r),1+max(r)]);
ylim(haxes,[-max(r),1+max(r)]);

fntszprobdat = points2data(haxes,fntszprob,'y');
for j1 = 1:J
    [x01,y01] = posoncircle(j1,J,theta0);
    for j2 = 1:J
        if j1==j2 || tp(j1,j2,1)==0
            continue
        end
        [x02,y02] = posoncircle(j2,J,theta0);
        
        % calculates angle between states
        a = x02-x01;
        b = y02-y01;
        c = sqrt((a^2)+(b^2));
        costheta = a/c;
        sintheta = b/c;
        theta = acos(costheta);
        if sintheta<0
            theta = pi-theta;
        end
        
        % shift arrows
        dy = darr*sin(theta-pi/2);
        dx = darr*cos(theta-pi/2);
        if j2>j1
            xa1 = x01+dx;
            xa2 = x02+dx;
            ya1 = y01+dy;
            ya2 = y02+dy;
        else
            xa1 = x01-dx;
            xa2 = x02-dx;
            ya1 = y01-dy;
            ya2 = y02-dy;
        end
        
        % shorten arrows
        dx1 = r(j1)*costheta;
        dy1 = r(j1)*sintheta;
        dx2 = r(j2)*costheta;
        dy2 = r(j2)*sintheta;
        xa1 = xa1+dx1;
        xa2 = xa2-dx2;
        ya1 = ya1+dy1;
        ya2 = ya2-dy2;
        
        % shift text coordinates
%         if J>3 && mod(round(180*theta/pi),90)>0
%             xt = (3*xa1+xa2)/4;
%             yt = (3*ya1+ya2)/4;
%         else
            xt = (xa1+xa2)/2;
            yt = (ya1+ya2)/2;
%         end
        dx = (fntszprobdat/2)*cos(theta-pi/2);
        dy = (fntszprobdat/2)*sin(theta-pi/2);
        if j2>j1
            xt = xt+dx;
            yt = yt+dy;
        else
            xt = xt-dx;
            yt = yt-dy;
        end
        
        % convert to figure referencial
        [xa1,ya1] = posax2posfig(haxes,xa1,ya1);
        [xa2,ya2] = posax2posfig(haxes,xa2,ya2);
        
        % annotates with arrow
        arr = annotation(hpar,'arrow');
        chld = cat(2,chld,arr);
        set(arr,'units',haxes.Units,'x',[xa1,xa2],'y',[ya1,ya2],'color',...
            axclr,'headlength',hdlgth,'headwidth',hdlgth);
        if tp(j1,j2,1)<=eps
            str = strnull;
            arr.LineStyle = ':';
        else
            if tp(j1,j2,1)<(5*10^-(signb+1))
                expnt = 0;
                while fix(tp(j1,j2,1)/10^-expnt)==0
                    expnt = expnt+1;
                end
                str = sprintf('%i',round(tp(j1,j2,1)/10^-expnt));
            else
                str = sprintf(['%.',num2str(signb),'f'],tp(j1,j2,1));
            end
            if size(tp,3)>=2
                if tp<(5*10^-(signb+1))
                    str = cat(2,'(',str,' ',char(177),' ',...
                        sprintf(['%.',num2str(signb),'f)'],tp(j1,j2,2)));
                else
                    str = cat(2,str,' ',char(177),' ',...
                        sprintf('%i',round(tp(j1,j2,2)/10^-expnt)));
                end
            end
            if tp(j1,j2,1)<(5*10^-(signb+1))
                str = cat(2,str,[char(183),'10^{-',num2str(expnt),'}']);
            end
        end
        if insec
            str = cat(2,str,' /s');
        end
        
        % calculates text rotation angle
        rotangle = 180*theta/pi;
        if rotangle>90 && rotangle<270
            rotangle = rotangle-180;
        end
        if rotangle<-90 && rotangle>-270
            rotangle = rotangle+180;
        end
        
        % annotates with text
        if addtxt
            chld = cat(2,chld,text(haxes,xt,yt,str,'rotation',rotangle,...
                'horizontalalignment','center','verticalalignment',...
                'middle','fontunits','points','fontsize',fntszprob));
        end
    end
end

% prop'ups axis
xlim(haxes,[-max(r),1+max(r)]);
ylim(haxes,[-max(r),1+max(r)]);

% resets figure units
setparentnorm2un(haxes,parun);


function [x,y] = posoncircle(j,J,theta0)
theta = 2*pi*(theta0+(j-1)*(360/J))/360;
x = (1+cos(theta))/2;
y = (1+sin(theta))/2;


function d = points2data(h_axes,d,dir)

% converts points to inches
d = points2inch(d);

% collects axes dimensions in inches
axun = h_axes.Units;
h_axes.Units = 'inches';
switch dir
    case 'y'
        daxes = h_axes.Position(4);
    otherwise
        daxes = h_axes.Position(3);
end
h_axes.Units = axun;

% converts inches to data
switch dir
    case 'y'
        dlim = h_axes.YLim(2)-h_axes.YLim(1);
    otherwise
        dlim = h_axes.XLim(2)-h_axes.XLim(1);
end
d = (d/daxes)*dlim;


function [x,y] = posax2posfig(h_axes,x,y)

% converts coordinates to axes referential
x = (x-h_axes.XLim(1))/(h_axes.XLim(2)-h_axes.XLim(1));
y = (y-h_axes.YLim(1))/(h_axes.YLim(2)-h_axes.YLim(1));

% converts coordinates to figure's referential
h_chld = h_axes;
while ~strcmp(h_chld.Type,{'uipanel','uitab','figure'})
    x0 = h_chld.Position(1);
    y0 = h_chld.Position(2);
    w0 = h_chld.Position(3);
    h0 = h_chld.Position(4);

    x = x*w0;
    y = y*h0;
    x = x+x0;
    y = y+y0;
    
    h_chld = h_chld.Parent;
end


function parun = setparentun2norm(chld)
parun = {};
while ~strcmp(chld.Type,{'uipanel','uitab','figure'})
    chld = chld.Parent;
    parun = cat(2,parun,chld.Units);
end
parun = cat(2,parun,chld.Units);


function setparentnorm2un(chld,parun)
p = 1;
while ~strcmp(chld.Type,{'uipanel','uitab','figure'})
    chld = chld.Parent;
    chld.Units = parun{p};
    p = p+1;
end
chld.Units = parun{p};


function par = getparent(chld)
while ~strcmp(chld.Type,{'uipanel','uitab','figure'})
    chld = chld.Parent;
end
par = chld;


function d = points2inch(d)
d = d/72;

