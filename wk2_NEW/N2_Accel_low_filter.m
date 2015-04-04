% 9th Mar
% Complemantary filter for raw accelel data
% Input: accel_X, accel_Y, accel_Z
% For calculation: accelX_SHT, accelY_SHT, accelZ_SHT means shift downward by 1
% Output: accelX_LFT, accelY_LFT, accelZ_LFT means filted data
% Factors: kFilterFactor, loop

close all;
% Low pass filter for accelelerometer: 
% Test 1: Exponential moving average EMA
kFilterFactor = 0.5;
data_size = length(accelX);
accelX_LFT = zeros(data_size,1); % Create result matrix: accelX filtered
accelX_LFT = accelX;     % Assign init value
accelY_LFT = accelY;
accelZ_LFT = accelZ;

for loop=1:6
accelX_SHT = circshift(accelX_LFT,1);
accelY_SHT = circshift(accelY_LFT,1); 
accelZ_SHT = circshift(accelZ_LFT,1);

accelX_LFT = (accelX_LFT .* kFilterFactor) + (accelX_SHT .*(1-kFilterFactor));
accelY_LFT = (accelY_LFT .* kFilterFactor) + (accelY_SHT .*(1-kFilterFactor));
accelZ_LFT = (accelZ_LFT .* kFilterFactor) + (accelZ_SHT .*(1-kFilterFactor));
end

% % Test 2:  Simple moving Average (SMA)
% % Comment: Filtering great but earse out all the features: Unable to
% % calculate angle
% accelX_LFT = accel_X;     % Assign init value
% accelY_LFT = accel_Y;
% accelZ_LFT = accel_Z;
% tap=1;  
% for loop=(tap+1):+3:(data_size-tap)
% accelX_LFT(loop) = mean(accel_X(loop-tap):accel_X(loop+tap));
% accelY_LFT(loop) = mean(accel_Y(loop-tap):accel_Y(loop+tap));
% accelZ_LFT(loop) = mean(accel_Z(loop-tap):accel_Z(loop+tap));
% end
figure(1);
plot(time,accelX,'m');
hold on;
plot(time,accelY,'b');
hold on;
plot(time,accelZ,'r');
title('accelel Raw data');
xlabel('Time(s)');
ylabel('Data(m/s^2)');
hold off;
legend('x','y','z');
grid on;

figure(2);
plot(time,accelX_LFT,'m');
hold on;
plot(time,accelY_LFT,'b');
hold on;
plot(time,accelZ_LFT,'r');
title('accelel Complementary Filtered data');
xlabel('Time(s)');
ylabel('Data(m/s^2)');
hold off;
legend('x','y','z');
grid on;
