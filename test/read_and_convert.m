function proj_mat = read_and_convert(n)
% read camera parameters and convert into 3 by 4 matrix
% NOTE:
% n --- number of cameras
% OUTPUT is "proj_mat"

% projection matrix (FINAL RESULTS)
proj_mat = zeros(3, 4, n);

for ii=1:n
    name = ii-1;
    name = sprintf('%08d', name);
    name = ['c:\tmp\cam_001_' name '.txt'];
    fid = fopen(name, 'r');
    
    % lens
    lens = fscanf(fid, '%f\n', 1);
    
    % sensor
    sensor_w = fscanf(fid, '%f', 1);
    sensor_h = fscanf(fid, '%f\n', 1);
    
    % size
    size_w = fscanf(fid, '%f', 1);
    size_h = fscanf(fid, '%f\n', 1);
    
    % pixel to unit
    sensor_w = sensor_w / size_w;
    sensor_h = sensor_h / size_h;
    
    % shift
    shift_w = size_w/2*sensor_w;
    shift_h = size_h/2*sensor_h;
    
    % RT
    RT = fscanf(fid, '%f', [4, 3]);
    RT = RT';
    
    % compute K
    K = [lens    0 shift_w; ...
            0 lens shift_h; ...
            0    0      1];
    K(1,:) = K(1,:)/sensor_w;
    K(2,:) = K(2,:)/sensor_h;
    % change global coordinates
    % trans_mat = [1 0 0; 0 -1 0; 0 0 -1];
    trans_mat = [1 0 0; 0 1 0; 0 0 1];
    % compute projection matrix
    proj_mat(:,:, ii ) = K*trans_mat*RT;
    
    fclose(fid);
end
end