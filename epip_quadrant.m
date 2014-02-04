function [epip_in_image,p] = epip_quadrant(e,dim)

% Cartesian space is split into 9 parts as in the image below. This function
% calcs the part that the epipole is located in. This is used to find 
% bounds of \theta for the image in polar system.
%
%       |                 |
%     1 |        2        | 3
%    ---+-----------------+---
%       |a               b|
%       |                 |
%     4 |        5        | 6
%       |                 |
%       |                 |
%       |c               d|
%    ---+-----------------+---
%     7 |        8        | 9
%       |                 |
%
% input args:
%   e - the epipole
%   dim = [width,height] - dimensions of the image
%
%   p(1:2,1),p(1:2,2) are image plane coordinates of corners pixels that
%   define the polar cone that needs to be processed
%   epip_in_image is true if the epipole is in the image and false
%   otherwise

x = e(1); y = e(2);
%              a ;      b    ;    c   ;    d     ]
im_corners = [0 dim(1);dim(2) dim(1);0 0;dim(2) 0]';

ii_c = [];
% please note that the order of corners in ii_c below is important since we
% will iterate \theta from ii_c(1) to ii_c(2) clockwise, so this range 
% should be in the the image

if x<=0 && y<=0
    % q = 1, b -> c
    ii_c = [2 3];
end

if x>=0 && x<=dim(1) && y<=0
    % q = 2
    ii_c = [2 1];
end

if x>=dim(1) && y <= 0
    % q = 3
    ii_c = [4 1];
end

if x<=0 && y>=0 && y<=dim(2)
    % q = 4
    ii_c = [3 1];
end

if x>=0 && x<=dim(1) && y>=0 && y<=dim(2)
    % epipole is in the image
    % q = 5
    ii_c = [];
end

if x>=dim(1) && y>=0 && y<=dim(2)
    % q = 6
    ii_c = [2 4];
end

if x<=0 && y>=0 && y>=dim(2)
    % q = 7
    ii_c = [4 1];
end

if x>=0 && x<=dim(1) && y>=0 && y>=dim(2)
    % q = 8
    ii_c = [3 4];
end

if x>=dim(1) && y>=0 && y>=dim(2)
    % q = 9
    ii_c = [3 2];
end

if isempty(ii_c)
    epip_in_image = true;
    p = nan(2,2);
else
    epip_in_image = false;
    p(:,1) = im_corners(:,ii_c(1));
    p(:,2) = im_corners(:,ii_c(2));
end