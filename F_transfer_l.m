function l2 = F_transfer_l(H,l1)

l2 = H'\l1;
l2 = l2/norm(l2(1:2));

