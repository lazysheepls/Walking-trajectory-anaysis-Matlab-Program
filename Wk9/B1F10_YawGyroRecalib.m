%% B1F10 function: Gyro Yaw angle recalibrated before datafusion
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F10 function: 1.Flip gyro angle: 360-YawGyro
%                        2.add inital compass angle to all data
%                        3.The whole purpose is to align gyro angle with
%                        GPS and compass angle
%   INPUT: YawGyro,XcodeTrueHeading,time
%  OUTPUT: YawGyroCalib

%% Function
function [YawGyroCalib,InitHeading] = B1F10_YawGyroRecalib(XcodeTrueHeading,GPScourse,YawGyro,time)
% flip the angle
YawGyroCalib = 360-YawGyro;

% Add initial compass heading as reference: first 10s is for calib
% 10/(time(2)-time(1))=171.57 samples
InitHeading = XcodeTrueHeading(1);
YawGyroCalib = YawGyroCalib + XcodeTrueHeading(1);

% Rescale to 0 to 360 degree
for i=1:length(YawGyroCalib)
    if YawGyroCalib(i)>360
       YawGyroCalib(i) = YawGyroCalib(i)-360;
    elseif YawGyroCalib(i)<0
       YawGyroCalib(i) = YawGyroCalib(i)+360;
    end
end

% Plot: Angle compare
figure;
plot(time,GPScourse,'b');
hold on; plot(time,XcodeTrueHeading,'r');
hold on; plot(time,YawGyroCalib,'c');
legend('GPScourse','CompassHeading','GyroCalib');
title('Data Fusion Prep: Heading Compare');
end