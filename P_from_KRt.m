function P = P_from_KRt(K,R,t)

%% FULL CALIBRATION from camera intrinsics (K) and rigid transformation (R,t)
P = K*[R t];
