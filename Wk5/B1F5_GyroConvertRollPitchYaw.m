%% B1F5 function: Convert Gyroscope filtered data to roll pitch & yaw angle
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F6 function: - 1.Calculate sample data time interval
%                        - 2.Use accumulation(integral) converted to angle
%                        - 3.Solve rotation over 360 degree problem
%   INPUT: time
%          gyroXft,gyroYft,gyroZft
%  OUTPUT: RollGyro,PitchGyro,YawGyro ***NOTE: only YawGyro is properly
%  calibrated for now!!!!
%% Function
function [RollGyro,PitchGyro,YawGyro] = B1F5_GyroConvertRollPitchYaw(time,gyroXft,gyroYft,gyroZft)
% Time interval
deltaT= time(2)-time(1);
% initial gyro angle
RollGyro(1) = gyroXft(1); 
PitchGyro(1) = gyroYft(1);
YawGyro(1) = gyroZft(1);
GyroShiftFactor = 0.02;
% Gyro angle
for n=2:length(time)
    % Accumulation(Integral) method: Convert angular speed to angle
    RollGyro(n,1) = RollGyro(n-1,1)+gyroXft(n) .* deltaT .*180./pi;
    PitchGyro(n,1) = PitchGyro(n-1,1)+gyroYft(n) .* deltaT .*180./pi;
    YawGyro(n,1) = YawGyro(n-1,1)+gyroZft(n) .* deltaT .*180./pi;
    % Solve roation over 360 degree problem
    if RollGyro(n,1)>360
        RollGyro(n,1) = RollGyro(n,1)-360;
    end
    if PitchGyro(n,1)>360
        PitchGyro(n,1) = PitchGyro(n,1)-360;
    end
    if YawGyro(n,1)>360
        YawGyro(n,1) = YawGyro(n,1)-360;
    end
    
    if RollGyro(n,1)<0
        RollGyro(n,1) = RollGyro(n,1)+360;
    end
    if PitchGyro(n,1)<0
        PitchGyro(n,1) = PitchGyro(n,1)+360;
    end
    if YawGyro(n,1)<0
        YawGyro(n,1) = YawGyro(n,1)+360;
    end
end
% YawGyro=YawGyro-GyroShiftFactor
%plot
figure;
plot(time,RollGyro,'r');hold on;
plot(time,PitchGyro,'g');hold on;
plot(time,YawGyro,'b');
legend('Roll','Pitch','Yaw');
title ('Pitch Roll and Yaw angle based on Gyro Data only');
xlabel('Time(s)');ylabel('Angle(degree)');
hold off;grid on;
end