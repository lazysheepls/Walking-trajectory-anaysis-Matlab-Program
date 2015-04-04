close all;
x = time;
% Coefficients (with 95% confidence bounds):
        a0 =  -3.296e+11  (-2.546e+16, 2.546e+16);
       a1 =   4.395e+11  (-3.394e+16, 3.394e+16);
       b1 =  -3.274e+09  (-1.896e+14, 1.896e+14);
       a2 =  -1.099e+11  (-8.485e+15, 8.485e+15);
       b2 =   1.637e+09  (-9.482e+13, 9.482e+13);
       w =  -0.0009489  (-18.32, 18.32);
% General model Fourier2:
y =  a0 + a1*cos(x.*w) + b1.*sin(x.*w) + a2*cos(2.*x.*w) + b2.*sin(2.*x.*w);
figure;
plot(y);

