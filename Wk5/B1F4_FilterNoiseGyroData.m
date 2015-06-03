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
function [gyroXft,gyroYft,gyroZft,shiftX,shiftY,shiftZ] = B1F4_FilterNoiseGyroData(time,gyroX,gyroY,gyroZ,shiftX,shiftY,shiftZ,CalibFactor)
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
% for gyroLoop=1:6
% gyroXSHT = circshift(gyroXft,1);
% gyroYSHT = circshift(gyroYft,1); 
% gyroZSHT = circshift(gyroZft,1);
% 
% gyroXft = (gyroXft .* kFilterFactor) + (gyroXSHT .*(1-kFilterFactor));
% gyroYft = (gyroYft .* kFilterFactor) + (gyroYSHT .*(1-kFilterFactor));
% gyroZft = (gyroZft .* kFilterFactor) + (gyroZSHT .*(1-kFilterFactor));
% end

% Cancel gyro bias and shifting
% Calulate shift factor for X Y Z data

% Try to improve the accuracy and remove strange spike from calibration
% Method 1: Find value close to 0 within first 150 data: 8.7sec
if CalibFactor == 1
count = length(gyroXft);

Xabs = abs(gyroXft(1:count));
[x,Xindex]=sort(Xabs);
minX=gyroXft(Xindex(1));   % X reading closest to 0

Yabs = abs(gyroYft(1:count));
[y,Yindex]=sort(Yabs);
minY=gyroYft(Yindex(1));    % Y reading closest to 0

Zabs = abs(gyroZft(1:count));
[z,Zindex]=sort(Zabs);
minZ=gyroZft(Zindex(1));    % Z reading closest to 0

clearvars x y z Xindex Yindex Zindex;
limit = 10;
[x,Xindex]=find(abs((gyroXft(1:count)-minX))<limit);
shiftX = mean(gyroXft(x));

[y,Yindex]=find(abs((gyroYft(1:count)-minY))<limit);
shiftY = mean(gyroYft(y));

[z,Zindex]=find(abs((gyroZft(1:count)-minZ))<limit);
shiftZ = mean(gyroZft(z));
end

% Method 2: Directly take average from 100-170 data: 6-10sec
% sta = 100;
% fin = 170;
% shiftX = mean(gyroXft(sta:fin,1));
% shiftY = mean(gyroYft(sta:fin,1));
% shiftZ = mean(gyroZft(sta:fin,1));


% Elimate bias: Complementary filtered data
% wk9 data only
% gyroXft = gyroXft - shiftX-0.006;
% gyroYft = gyroYft - shiftY+0.01;
% gyroZft = gyroZft - shiftZ+0.0058;  % magic number: for wk9 data only

gyroXft = gyroXft - shiftX;
gyroYft = gyroYft - shiftY;
gyroZft = gyroZft - shiftZ+0.0085;  % magic number: for wk9 data only
% +0.0058
%% Compare raw data with filtered data
figure;
% Raw data
subplot(1,2,1);
plot(time,gyroX,'m');hold on;
plot(time,gyroY,'b');hold on;
plot(time,gyroZ,'r');
title('gyroel 04 Raw data');
xlabel('Time(s)');ylabel('Angular speed(rad/s)');
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