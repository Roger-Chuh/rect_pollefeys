function [ps,epip2cross] = im_pixel_points(l,e,dim)

% line equations of image boundaries
border_lines = [0,1,0;1,0,0;1,0,-dim(2);0,1,-dim(1)]';
ps = [];
epip2cross = nan(1,2);

% each column is a point p, s.t. l crosses the corresponding boundary at p
% we need to find a pair that is inside the visible image
border_cross = round(h2e(cross(border_lines,repmat(l,[1 4]))));

border_cross = border_cross(:,border_cross(1,:) <= dim(2) & ...
    border_cross(1,:) >=0 & border_cross(2,:) <= dim(1) & ...
    border_cross(2,:) >= 0);

if isempty(border_cross) || size(border_cross,1) < 2
    return
end

epip2cross = [norm(e-border_cross(:,1)); norm(e-border_cross(:,2))];

if epip2cross(1)>epip2cross(2)
    border_cross = fliplr(border_cross);
    epip2cross = flipud(epip2cross);
end

inside_len = uint32(epip2cross(2)-epip2cross(1));
if inside_len == 0
    return
end

% l direction
du = border_cross(1:2,2)-border_cross(1:2,1);
du = du/norm(du);

% generate the points
ps = repmat(border_cross(1:2,1),1,inside_len) + [double((0:(inside_len-1)))*du(1);double((0:(inside_len-1)))*du(2)];

% [x,y] = bresenham(xb(1,1),xb(2,1),xb(1,2),xb(2,2));
% ps = cat(2,x,y)';
