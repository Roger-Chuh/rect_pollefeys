function h = plot_line_in_image(l1)

if l1(2) ~= 0
    x = [0 1];
    y = [-l1(3)/l1(2) (-l1(3)-l1(1))/l1(2)];
else
    x = [0 0];
    y = [0 1];
end
hold on;
h = line(x,y);
end
