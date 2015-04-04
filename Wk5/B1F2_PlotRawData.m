%% B1F2 function: Plot Raw data
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F2 function: -Plot accelX,Y,Z raw data
%                        -Plot gyroX,Y,Z raw data
%                        -Plot magneticX,Y,Z raw data
%                        -Plot XcodeHeading True,Magnetic real data
%   INPUT: time
%          accelX,accelY,accelZ
%          gyroX,gyroY,gyroZ
%          magnetX,magnetY,magnetZ
%          XcodeTrueHeading,XcodeMagneticHeading
%  OUTPUT: 4 figures in a subplot form

%% Function
function [] = B1F2_PlotRawData(time,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magnetX,magnetY,magnetZ,XcodeTrueHeading,XcodeMagneticHeading)
figure;
%  Accelerometer Raw data
subplot(2,2,1);
plot(time,accelX,'r');hold on;
plot(time,accelY,'g');hold on;
plot(time,accelZ,'b');hold on;
title('Accel Raw Data');
xlabel('Time(s)'); ylabel('Linear acceleration(m/s^2)');
hold off;
grid on;
legend('x','y','z');

%  Gyroscope Raw data
subplot(2,2,2);
plot(time,gyroX,'r');hold on;
plot(time,gyroY,'g');hold on;
plot(time,gyroZ,'b');hold on;
title('Gyro Raw Data');
xlabel('Time(s)'); ylabel('Angular speed (rad/s)');
hold off;
grid on;
legend('x','y','z');

%  Magnetometer Raw data
subplot(2,2,3);
plot(time,magnetX,'r');hold on;
plot(time,magnetY,'g');hold on;
plot(time,magnetZ,'b');hold on;
title('Magnetometer Raw Data');
xlabel('Time(s)'); ylabel('Magnetic Strength(uT)');
hold off;
grid on;
legend('x','y','z');

%  Magnetometer Xcode heading data
subplot(2,2,4);
plot(time,XcodeMagneticHeading,'r');hold on;
plot(time,XcodeTrueHeading,'b');hold on;
title('Magnetometer Xcode Heading Data');
xlabel('Time(s)'); ylabel('Heading angle(degree)');
hold off;
grid on;
legend('Magnetic Heading','True Heading');
end