% 10 Mar
% Transfer filtered accel data to angle related to XY, XZ, YZ plane
% Input: accX_LFT, accY_LFT, accZ_LFT
% Testing: angular calculation of raw data to angular calculation of
% filtered data from File: Accelerometer_filter1.m
% Output: accel_AxyRawD, accel_AxyFilteredD  means raw and filtered in degree
close all;

accel_AxyRawR = atan2(acc_Y,acc_X);
accel_AxyRawD = 180 .* accel_AxyRawR ./ pi;

accel_AxyFilteredR = atan2(accY_LFT,accX_LFT);
accel_AxyFilteredD = 180 .* accel_AxyFilteredR ./ pi;


figure(1);
subplot(1,2,1);
plot(time,accel_AxyRawD,'r');
legend('Raw');
title('Angular Calculation for Raw Data, XY surface');
xlabel('time(s)');
ylabel('Angle(degree)');
grid on;
subplot(1,2,2);
plot(time,accel_AxyFilteredD,'b');
legend('Filtered');
title('Angular Calculation for Filtered Data, XY Surface');
xlabel('time(s)');
ylabel('Angle(degree)');
grid on;