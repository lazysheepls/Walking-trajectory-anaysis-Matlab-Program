% 9th Mar
% Complemantary filter for raw gyroel data
% Input: gyroX, gyroY, gyroZ
% For calculation: gyroXSHT, gyroYSHT, gyroZSHT means shift downward by 1
% Output: gyroXft, gyroYft, gyroZft means filted data
% Factors: kFilterFactor, loop

close all;
% Low pass filter for gyroelerometer: 
% Test 1: Exponential moving average EMA
kFilterFactor = 0.5;
datasize = length(gyroX);
gyroXft = zeros(datasize,1); % Create result matrix: gyroX filtered
gyroXft = gyroX;     % Assign init value
gyroYft = gyroY;
gyroZft = gyroZ;

for loop=1:6
gyroXSHT = circshift(gyroXft,1);
gyroYSHT = circshift(gyroYft,1); 
gyroZSHT = circshift(gyroZft,1);

gyroXft = (gyroXft .* kFilterFactor) + (gyroXSHT .*(1-kFilterFactor));
gyroYft = (gyroYft .* kFilterFactor) + (gyroYSHT .*(1-kFilterFactor));
gyroZft = (gyroZft .* kFilterFactor) + (gyroZSHT .*(1-kFilterFactor));
end

% % Test 2:  Simple moving Average (SMA)
% % Comment: Filtering great but earse out all the features: Unable to
% % calculate angle
% gyroXft = gyroX;     % Assign init value
% gyroYft = gyroY;
% gyroZft = gyroZ;
% tap=1;  
% for loop=(tap+1):+3:(datasize-tap)
% gyroXft(loop) = mean(gyroX(loop-tap):gyroX(loop+tap));
% gyroYft(loop) = mean(gyroY(loop-tap):gyroY(loop+tap));
% gyroZft(loop) = mean(gyroZ(loop-tap):gyroZ(loop+tap));
% end
figure(1);
plot(time,gyroX,'m');
hold on;
plot(time,gyroY,'b');
hold on;
plot(time,gyroZ,'r');
title('gyroel 04 Raw data');
xlabel('Time(s)');
ylabel('Data(m/s^2)');
hold off;
legend('x','y','z');
grid on;

figure(2);
plot(time,gyroXft,'m');
hold on;
plot(time,gyroYft,'b');
hold on;
plot(time,gyroZft,'r');
title('gyroel 04 Complementary Filtered data');
xlabel('Time(s)');
ylabel('Angular speed(rad/s)');
hold off;
legend('x','y','z');
grid on;
