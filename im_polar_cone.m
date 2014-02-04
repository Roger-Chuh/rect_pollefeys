function [theta,l] = im_polar_cone(e,dim)

% Consider polar coordinate system with origin at the epipole e; also
% cosider cartesian image coordinate system with ll=(0,0);
% The image rectangle lies inside cone defined by \theta(1) and \theta(2)
% im_polar_cone calculates this cone that needs to be processed
% assume that \theta = 0 is the direction of the x-axis in the image

% input args:
% e is the epipole
% dim = [w,h] dimensions of the image
% output args:
% theta 1x2 are polar angles of cone sides 
% l(1:3,1:2) are the equations of the cone side lines

theta   = nan(2,1);

% image corners that define polar cone of interest
[epip_in_image,p] = epip_quadrant(e,dim);

if epip_in_image, % p is empty in this case
    theta(1) = 0;
    theta(2) = 2*pi;
else
    % direction from the epipole to the 1st corner
    ep1 = p(1:2,1)-e(1:2); ep1 = ep1/(ep1'*ep1);
    ep2 = p(1:2,2)-e(1:2); ep2 = ep2/(ep2'*ep2);

    % angle with x-axis
    theta(1) = atan2(ep1(2),ep1(1));
    theta(2) = atan2(ep2(2),ep2(1));
    
    % theta should be [0;2pi] instead of [-pi;pi]
    if theta(1) < 0, theta(1) = 2*pi+theta(1); end
    if theta(2) < 0, theta(2) = 2*pi+theta(2); end
end
