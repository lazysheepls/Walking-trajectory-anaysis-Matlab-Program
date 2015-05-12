%% B1F6 function: Convert Accelerometer filtered data to roll and pitch angle
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F5 function: - 1.Use complementary filter(low pass) kill noise
%                        - 2.Plot raw data compare with filtered data
%   INPUT: time
%          accelXft,accelYft,accelZft 
%  OUTPUT: RollAccel,PitchAccel
%% Function
function [RollAccel,PitchAccel] = B1F5_AccelConvertRollPitch(time,accelXft,accelYft,accelZft)
% Calculate tilt angle respect to Y Axis
% Also is rotation around X axis: Roll
RollAccel = (atan2(accelYft,sqrt(accelXft.^2 + accelZft.^2))).*180./pi;

% Calculate tilt angle respect to X Axis
% Also is rotation around Y axis: Pitch
PitchAccel = (atan2(accelXft,sqrt(accelYft.^2 + accelZft.^2))).*180./pi;

figure;
plot(time,RollAccel,'r');hold on;
plot(time,PitchAccel,'b');hold off;grid on;
legend('Roll','Pitch');
title ('Roll abd pitch angle based on accelel Data only');
xlabel('Time(s)');
ylabel('Angle(degree)');
hold off;
end