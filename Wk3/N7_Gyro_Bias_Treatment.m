% Wk3
% Deal with gyro data shifting program
% Method: When collecting data, let phone set still for a while. Then, when
% analysis data, use front data to get a linear equation. Then, use gyro
% filtered data minus this linear equation to get rid of the bias
% Input: AngleGY_X, AngleGY_Y, AngleGY_Z

% Bias function: y=fa_x * t + fb_x
%                y=fa_y * t + fb_y
%                y=fa_z * t + fb_z
close all;
% Calibration time 10sec
data1 = 100; 
data2 = 10;
% Gyro X
fa_x = (AngleGY_X(data1) - AngleGY_X(data2))/(time(data1)-time(data2));
fb_x = AngleGY_X(data1) - fa_x * time(data1);
FgyroBias_x = fa_x .* time + fb_x;
% Gyro Y
fa_y = (AngleGY_Y(data1) - AngleGY_Y(data2))/(time(data1)-time(data2));
fb_y = AngleGY_Y(data1) - fa_y * time(data1);
FgyroBias_y = fa_y .* time + fb_y;
% Gyro Z
fa_z = (AngleGY_Z(data1) - AngleGY_Z(data2))/(time(data1)-time(data2));
fb_z = AngleGY_Z(data1) - fa_z * time(data1);
FgyroBias_z = fa_z .* time + fb_z;

% Apply bias functions to filtered gyro data
AngleGYbias_X = AngleGY_X - FgyroBias_x;
AngleGYbias_Y = AngleGY_Y - FgyroBias_y;
AngleGYbias_Z = AngleGY_Z - FgyroBias_z;

figure;
plot(time,AngleGYbias_X,'r');
hold on;
plot(time,AngleGYbias_Y,'b');
hold on;
plot(time,AngleGYbias_Z,'m');
hold off;
grid on;
title('Gyro angle after bias canellation');
xlabel('time(s)');
ylabel('Angle(degree)');
legend('x','y','z');

% Problem: Gyro angle should in the range of 0 to 360 degree
% Therefore, this program need to change