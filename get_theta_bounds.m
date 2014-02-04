function theta = get_theta_bounds(e1,e2,F,dim)

% calc the bounds on theta in the first image, since we iterate over it
[theta1,~] = get_theta(e1,dim);
[~,l2] = get_theta(e2,dim);

% transfer image2 cone bounding lines into the image1 and calc the angles
l2(:,1) = F_transfer_l(F,l2(:,1),e2);
l2(:,2) = F_transfer_l(F,l2(:,2),e2);
theta2(1) = l_get_angle(l2(:,1));
theta2(2) = l_get_angle(l2(:,2));

% when does this happen?
if theta2(1)>theta2(2)
    theta2 = flipud(theta2);
end

theta(1) = max(theta1(1),theta2(1));
theta(2) = min(theta1(2),theta2(2));