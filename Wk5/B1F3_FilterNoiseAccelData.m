%% B1F3 function: Filter accel noise from raw data
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F3 function: - 1.Use complementary filter(low pass) kill noise
%                        - 2.Plot raw data compare with filtered data
%   INPUT: time
%          accelX,accelY,accelZ  
%  OUTPUT: accelXft,accelYft,accelZft

%% Function
function [accelXft,accelYft,accelZft] = B1F3_FilterNoiseAccelData(time,accelX,accelY,accelZ)
% Complementary Filter for accelrometer
kFilterFactor = 0.5;
accelLoop = 6;

% Initial var declear
accelSize = length(accelX);
accelXft = zeros(accelSize,1); % Create result matrix: accelX filtered
accelXft = accelX;     % Assign init value
accelYft = accelY;
accelZft = accelZ;

% Apply complementary filter
for accelLoop=1:6
accelXshift = circshift(accelXft,1);
accelYshift = circshift(accelYft,1); 
accelZshift = circshift(accelZft,1);

accelXft = (accelXft .* kFilterFactor) + (accelXshift .*(1-kFilterFactor));
accelYft = (accelYft .* kFilterFactor) + (accelYshift .*(1-kFilterFactor));
accelZft = (accelZft .* kFilterFactor) + (accelZshift .*(1-kFilterFactor));
end

%% Compare raw data with filtered data
figure;
% Raw data
subplot(1,2,1);
plot(time,accelX,'m');hold on;
plot(time,accelY,'b');hold on;
plot(time,accelZ,'r');
title('Accel Raw data');
xlabel('Time(s)');ylabel('Data(m/s^2)');
hold off;grid on;
legend('x','y','z');
% Filtered data
subplot(1,2,2);
plot(time,accelXft,'m');hold on;
plot(time,accelYft,'b');hold on;
plot(time,accelZft,'r');
title('Accel Complementary Filtered data');
xlabel('Time(s)');ylabel('Data(m/s^2)');
hold off;grid on;
legend('x','y','z');
end