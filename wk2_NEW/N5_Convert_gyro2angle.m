% Wk2
% Convert filtered gyro data to angle
% Input: gyroXft, gyroYft, gyroZft
% Output: AngleGY_X, AngleGY_Y, AngleGY_Z
% Rotation around X: Pitch
close all;
% Time interval
deltaT= time(2)-time(1);
% initial gyro angle
AngleGY_X(1) =0; 
AngleGY_Y(1) =0;
AngleGY_Z(1) =0;

% Gyro angle
for n=2:length(time)
AngleGY_X(n,1) = AngleGY_X(n-1,1)+gyroXft(n) .* deltaT .*180./pi;
AngleGY_Y(n,1) = AngleGY_Y(n-1,1)+gyroYft(n) .* deltaT .*180./pi;
AngleGY_Z(n,1) = AngleGY_Z(n-1,1)+gyroZft(n) .* deltaT .*180./pi;
end

%plot
figure;
plot(time,AngleGY_X,'r');
hold on;
plot(time,AngleGY_Y,'g');
hold on;
plot(time,AngleGY_Z,'b');
legend('x:pitch','y:roll','z:yaw');
title ('Pitch Roll and Yaw angle based on Gyro Data only');
xlabel('Time(s)');
ylabel('Angle(degree)');
grid on;