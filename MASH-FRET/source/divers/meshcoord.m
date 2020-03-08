function coord = meshcoord(vect)
% Same as meshgrid but for a maximum dimension of 6 and return coordinates

D = size(vect,2);
if D>=2
    va = vect{1};
    vb = vect{2};
end
if D>=3
    vc = vect{3};
end
if D>=4
    vd = vect{4};
end
if D>=5
    ve = vect{5};
end
if D>=6
    vf = vect{6};
end

switch D
    case 2
        coord = meshcoord_2(va,vb);
    case 3
        coord = meshcoord_3(va,vb,vc);
    case 4
        coord = meshcoord_4(va,vb,vc,vd);
    case 5
        coord = meshcoord_5(va,vb,vc,vd,ve);
    case 6
        coord = meshcoord_6(va,vb,vc,vd,ve,vf);
    otherwise
        disp(cat(2,'Error in meshcoord: the number of arguments exceeds 6',...
            ' or is lower than 2'));
        return
end

function coord = meshcoord_2(va,vb)
coord = [];
for i = 1:numel(va)
    for j = 1:numel(vb)
        coord = cat(1,coord,[va(i),vb(j)]);
    end
end

function coord = meshcoord_3(va,vb,vc)
coord = [];
for i = 1:numel(va)
    for j = 1:numel(vb)
        for k = 1:numel(vc)
            coord = cat(1,coord,[va(i),vb(j),vc(k)]);
        end
    end
end

function coord = meshcoord_4(va,vb,vc,vd)
coord = [];
for i = 1:numel(va)
    for j = 1:numel(vb)
        for k = 1:numel(vc)
            for l = 1:numel(vd)
                coord = cat(1,coord,[va(i),vb(j),vc(k),vd(l)]);
            end
        end
    end
end

function coord = meshcoord_5(va,vb,vc,vd,ve)
coord = [];
for i = 1:numel(va)
    for j = 1:numel(vb)
        for k = 1:numel(vc)
            for l = 1:numel(vd)
                for m = 1:numel(ve)
                    coord = cat(1,coord,[va(i),vb(j),vc(k),vd(l),ve(m)]);
                end
            end
        end
    end
end

function coord = meshcoord_6(va,vb,vc,vd,ve,vf)
coord = [];
for i = 1:numel(va)
    for j = 1:numel(vb)
        for k = 1:numel(vc)
            for l = 1:numel(vd)
                for m = 1:numel(ve)
                    for n = 1:numel(vf)
                        coord = cat(1,coord,...
                            [va(i),vb(j),vc(k),vd(l),ve(m),vf(n)]);
                    end
                end
            end
        end
    end
end

