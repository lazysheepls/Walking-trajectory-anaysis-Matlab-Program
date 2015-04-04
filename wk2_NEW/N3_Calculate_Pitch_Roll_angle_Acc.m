% Calculate tilt angle respect to Y Axis
% Also is rotation around X axis: Roll
close all;
RollAccel = (atan2(accelYft,sqrt(accelXft.^2 + accelZft.^2))).*180./pi;
figure;
plot(time,Ay_pitchX,'r');

% Calculate tilt angle respect to X Axis
% Also is rotation around Y axis: Pitch
PitchAccel = (atan2(accelXft,sqrt(accelYft.^2 + accelZft.^2))).*180./pi;
hold on;
plot(time,Ax_rollY,'b');

hold off;
legend('Roll','Pitch');
grid on;
title ('Pitch and roll angle based on accelel Data only');
xlabel('Time(s)');
ylabel('Angle(degree)');
hold off;