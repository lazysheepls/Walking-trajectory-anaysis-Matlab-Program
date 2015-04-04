% 9th Mar
% Complemantary filter for raw accel data
% Input: acc_X, acc_Y, acc_Z
% For calculation: accX_SHT, accY_SHT, accZ_SHT means shift downward by 1
% Output: accX_LFT, accY_LFT, accZ_LFT means filted data
% Factors: kFilterFactor, loop

close all;
% Low pass filter for Accelerometer: 
% Test 1: Exponential moving average EMA
kFilterFactor = 0.1;
data_size = length(acc_X);
accX_LFT = zeros(data_size,1); % Create result matrix: accX filtered
accX_LFT = acc_X;     % Assign init value
accY_LFT = acc_Y;
accZ_LFT = acc_Z;

for loop=1:30
accX_SHT = circshift(accX_LFT,1);
accY_SHT = circshift(accY_LFT,1); 
accZ_SHT = circshift(accZ_LFT,1);

accX_LFT = (accX_LFT .* kFilterFactor) + (accX_SHT .*(1-kFilterFactor));
accY_LFT = (accY_LFT .* kFilterFactor) + (accY_SHT .*(1-kFilterFactor));
accZ_LFT = (accZ_LFT .* kFilterFactor) + (accZ_SHT .*(1-kFilterFactor));
end

% % Test 2:  Simple moving Average (SMA)
% % Comment: Filtering great but earse out all the features: Unable to
% % calculate angle
% accX_LFT = acc_X;     % Assign init value
% accY_LFT = acc_Y;
% accZ_LFT = acc_Z;
% tap=1;  
% for loop=(tap+1):+3:(data_size-tap)
% accX_LFT(loop) = mean(acc_X(loop-tap):acc_X(loop+tap));
% accY_LFT(loop) = mean(acc_Y(loop-tap):acc_Y(loop+tap));
% accZ_LFT(loop) = mean(acc_Z(loop-tap):acc_Z(loop+tap));
% end
figure(1);
plot(time,acc_X,'m');
hold on;
plot(time,acc_Y,'b');
hold on;
plot(time,acc_Z,'r');
title('Accel 04 Raw data');
xlabel('Time(s)');
ylabel('Data(m/s^2)');
hold off;
legend('x','y','z');
grid on;

figure(2);
plot(time,accX_LFT,'m');
hold on;
plot(time,accY_LFT,'b');
hold on;
plot(time,accZ_LFT,'r');
title('Accel 04 Complementary Filtered data');
xlabel('Time(s)');
ylabel('Data(m/s^2)');
hold off;
legend('x','y','z');
grid on;
