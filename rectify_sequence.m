disp('Program that rectifies a whole sequence of images');

dir;

fprintf(1,'\n');

seq_name_left = input('Basename of sequence images for left camera (without number nor suffix): ','s');
seq_name_right = input('Basename of sequence images for right camera (without number nor suffix): ','s');
fprintf(1,'assuming .jpg format');

ima_sequence_left = dir([seq_name_left '*.jpg']);
ima_sequence_right = dir([seq_name_right '*.jpg']);

if isempty(ima_sequence_left) || isempty(ima_sequence_right),
    fprintf(1,'No image found\n');
    return;
end;

n_seq = length(ima_sequence_left);

P_left = P_from_KRt(KK_left,eye(3),zeros(3,1));
P_right = P_from_KRt(KK_right,R,T);
F = vgg_F_from_P(P_left,P_right);

for kk = 1:n_seq,
    
    ima_name_left = ima_sequence_left(kk).name;
    expr = sprintf('%s(\\d+)',seq_name_left);
    tn = regexp(ima_name_left,expr,'tokens');
    ii = tn{1,1}{1,1};
    ima_name_right = sprintf('%s%s.jpg',seq_name_right,ii);
    fprintf(1,'Loading original images %s,%s...',ima_name_left,ima_name_right);
    
    i1 = im2double(imread(ima_name_left));
    i2 = im2double(imread(ima_name_right));
    
    ima_name_left2 = ['rect_' ima_name_left];
    ima_name_right2 = ['rect_' ima_name_right];
    
    [i1_rect,i2_rect] = rect_pollefeys(F',i1,i2);
    fprintf(1,'Saving rectified images under %s,%s...\n',ima_name_left2,ima_name_right2);
    
    imwrite(im2uint8(i1_rect),ima_name_left2);
    imwrite(im2uint8(i2_rect),ima_name_right2);
end;
