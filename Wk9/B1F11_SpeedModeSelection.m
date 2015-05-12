%% B1F11 function: Speed calculation and selection before data fusion
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F11 function: 1. Prepare 3 types of speed for latter use
%                         -  Type 1: GPSspeed(no further process needed)
%                         -  Type 2: Accel x,y combined speed
%                         -  Type 3: Step Size fixed average speed per step
%                         ** NOTE: Type 3 is not pedometer mode **
%   INPUT: YawGyro,XcodeTrueHeading,time
%  OUTPUT: YawGyroCalib

%% Function
function [GPSspeed,stepSpeed] = B1F11_SpeedModeSelection(GPSspeed,accelX,accelY,time,stepLocs,stepGaps,stepSize)
% speedMode 1: GPS speed mode
GPSspeed;

% speedMode 2: Average speed per step mode(NOTE: NOT Pedometer)
stepSpeed = [0];
stepSpeed = [stepSpeed;stepSize./stepGaps]; %speed for each step

% Insert data to fill the whole time frame
stepSpeedTemp = NaN(length(time),1);
stepSpeedTemp(1)=0;
stepSpeedTemp(stepLocs)=stepSpeed;
for i=2:length(stepSpeedTemp)
    if isnan(stepSpeedTemp(i))
        stepSpeedTemp(i)=stepSpeedTemp(i-1);
    end
end
clearvars stepSpeed;
stepSpeed = stepSpeedTemp;
clearvars stepSpeedTemp;

% Compare GPSspeed and stepSpeed
figure;
plot(time,GPSspeed,'r');
hold on; plot(time,stepSpeed,'b');
title('GPSspeed vs StepSpeed');
xlabel('time');ylabel('m/s');
legend('GPS speed','Step Speed');

% speedMode 3: Accel x,y speed mode:(**NOTE:NOT POSSIBLE SO FAR**)
% Method: sqrt(accelX.^2+accelY.^2)=magnitude of acceleration in XY plane

end