%% B1F4 function: Filter gyro noise from raw data
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F4 function: - 1.Use complementary filter(low pass) kill noise
%                        - 2.Elimate data bias
%                        - 3.Plot raw data compare with filtered data
%   INPUT: time
%          gyroX,gyroY,gyroZ  
%  OUTPUT: gyroXft,gyroYft,gyroZft

%% Function
function [gyroXft,gyroYft,gyroZft] = B1F4_FilterNoiseGyroData(time,gyroX,gyroY,gyroZ)
% Complementary Filter for accelrometer
kFilterFactor = 0.5;
gyroLoop = 6;

% Initial var declear
gyroSize = length(gyroX);
gyroXft = zeros(gyroSize,1); % Create result matrix: gyroX filtered
gyroXft = gyroX;     % Assign init value
gyroYft = gyroY;
gyroZft = gyroZ;

% Apply complementary filter
for gyroLoop=1:6
gyroXSHT = circshift(gyroXft,1);
gyroYSHT = circshift(gyroYft,1); 
gyroZSHT = circshift(gyroZft,1);

gyroXft = (gyroXft .* kFilterFactor) + (gyroXSHT .*(1-kFilterFactor));
gyroYft = (gyroYft .* kFilterFactor) + (gyroYSHT .*(1-kFilterFactor));
gyroZft = (gyroZft .* kFilterFactor) + (gyroZSHT .*(1-kFilterFactor));
end

% Cancel gyro bias and shifting
% Calulate shift factor for X Y Z data
count = 100;
shiftX = sum(gyroXft(1:count,1))/count;
shiftY = sum(gyroYft(1:count,1))/count;
shiftZ = sum(gyroZft(1:count,1))/count;
% Elimate bias
gyroXft = gyroXft - shiftX;
gyroYft = gyroYft - shiftY;
gyroZft = gyroZft - shiftZ;

%% Compare raw data with filtered data
figure;
% Raw data
subplot(1,2,1);
plot(time,gyroX,'m');hold on;
plot(time,gyroY,'b');hold on;
plot(time,gyroZ,'r');
title('gyroel 04 Raw data');
xlabel('Time(s)');ylabel('Data(m/s^2)');
hold off;grid on;
legend('x','y','z');
% Filtered data
subplot(1,2,2);
plot(time,gyroXft,'m');hold on;
plot(time,gyroYft,'b');hold on;
plot(time,gyroZft,'r');
title('gyroel 04 Complementary Filtered data');
xlabel('Time(s)');ylabel('Angular speed(rad/s)');
hold off;grid on;
legend('x','y','z');
end