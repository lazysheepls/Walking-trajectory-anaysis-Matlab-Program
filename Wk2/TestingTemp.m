close all;
a = [1;3;6;1;9;2;4;8;3];
b = [1;1;3;6;1;9;2;4;8];
kFilterFactor = 0.5;
c = (a .* kFilterFactor) + (b .*(1-kFilterFactor));
figure(1);
plot(a,'r');
hold on;
plot(c,'b');