function [i1_rect,i2_rect] = rect_pollefeys(F,i1,i2)

% function [i1_rect,i2_rect] = rect_pollefeys(i1,i2,F,P1,P2)
%
%	[i1_rect,i2_rect]=rect_pollefeys(i1,i2,F,P1,P2)
%
%
%Rectifies a pair of images related by fundamental F
%
% Input args
%	i1 - 1st image
%	i2 - 2nd image
%	F  - Fundamental s.t. p2'*F*p1=0
% Outputs:
%   [i1_rect,i2_rect] - rectified stereo pair

dbg = 1;

[w,h,~] = size(i1);

% row counter
row = 1;

% epipoles are left and right nullspace of F
e1 = h2e(null(F));
e2 = h2e(null(F'));

H = zeros(3,3);
while det(H) < eps
    a  = rand(3,1);
    H  = xprodmat(e2h(e2))*F+e2h(e2)*a';
end

% calc the polar cone that the image is in
theta_bounds = im_polar_cone(e1,[w h]);

% init theta
theta = theta_bounds(1);

if dbg,
    h1 = figure();
    imagesc(flipud(i1))
    colormap(gray)
    set(gca,'YDir','normal');
    h2 = figure();
    imagesc(flipud(i2))
    colormap(gray)
    set(gca,'YDir','normal');    
end

while theta <= theta_bounds(2)
    % equation of a line that passes thru e1 and has polar direction \theta
    l1 = l_from_theta_p(theta,e1);
    % pixels in image1
    [ps1{row},rr1(:,row)] = im_pixel_points(l1,e1,[w,h]);
    if isempty(ps1{row})
        theta = mod(theta+1/rr1(1,row),2*pi);
        continue;
    end
    % corresponding line in image2
    l2 = F_transfer_l(H,l1);
    % pixels in image2
    [ps2{row},rr2(:,row)] = im_pixel_points(l2,e2,[w,h]);
    if isempty(ps2{row}),
        theta = mod(theta+1/rr1(1,row),2*pi);
        continue;
    end
    
    if 1,
        figure(h1);
        hold on;
        x = round(ps1{row}(1,:));
        y = round(ps1{row}(2,:));
        plot(x,y,'r.');
        drawnow;
        figure(h2);
        hold on;
        x = round(ps2{row}(1,:));
        y = round(ps2{row}(2,:));
        plot(x,y,'r.');
        drawnow;
    end
    % theta update step
    dtheta(row) = min(1/rr1(1,row),1/rr2(1,row));
    % update theta
    theta = mod(theta+dtheta(row),2*pi);
    % row number
    row = row+1;
end

%% project images onto new (r,theta) coordtinates
dim = nan(3,1);
dim(1) = size(ps1,2);
rr1_w = max(rr1(2,:))-min(rr1(1,:));
rr2_w = max(rr2(2,:))-min(rr2(1,:));
dim(2) = round(max(rr2_w,rr1_w));
dim(3) = 3;

% warp the images
i1_rect = im_project(i1,ps1,rr1,dim);
i2_rect = im_project(i2,ps2,rr2,dim);
end

function pts=get_line_points(l,sz)
a=l(1); b=l(2);c=l(3);
h=sz(1); w=sz(2);

% This might cause 'divide by zero' warning:
ys=c/-b ;
yf=-(a*w+c)/b;
xs=c/-a;
xf=-(b*h+c)/a;

m1 = [[xs;1] [xf;h] [1;ys] [w;yf]];
w2 = [(xs<=w & xs>=1) (xf<=w & xf>=1) (ys<=h & ys>=1) (yf<=h & yf>=1)];
v = w2>0;
pts = [m1(:,v)];
end