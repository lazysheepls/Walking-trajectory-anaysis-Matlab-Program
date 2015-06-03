%% B1F12 function: Calibrate magnetometer
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F7 function: -1.Calibrate magnetometer
%                        -2.If MagnetCalibFactor=0, output normal constant
%                        -3.If MagnetCalibFactor=1, need recalibration
%   INPUT: MagnetCalibFactor
%          magnetX,magnetY,magnetZ
%  OUTPUT: magnetXCab,magnetYCab,magnetZCab
function [posXgyro,posYgyro,angleGyro,walkspeed,LonGyro,LatGyro] = B1F12_DataFusionBaseGyro(GPSspeed,stepSpeed,speedMode,YawGyroCalib,time,Lat,Lon,R)
% set speed for calculation
if speedMode==1
    walkspeed = stepSpeed;
else
    walkspeed = GPSspeed;
end
% Set the time interval
deltaT=time(2)-time(1);
% Initialise variables
posXgyro = [0];
posYgyro = [0];
angleGyro = [0];
LonGyro = [Lon(1)];
LatGyro = [Lat(1)];
% Conversion to distance and angle
for i=2:length(time)
    posXgyro(i,1) = posXgyro(i-1) + deltaT.*walkspeed(i).*cosd(angleGyro(i-1));
    posYgyro(i,1) = posYgyro(i-1) + deltaT.*walkspeed(i).*sind(angleGyro(i-1));
    angleGyro(i,1) = YawGyroCalib(i);
end

% Conversion to GPS coordinate:
%  Prep for distance and angle
Dis2PreGyro = zeros(length(posXgyro),1);
angle2PreGyro=zeros(length(posXgyro),1); %Angle between 2 points
for i=2:length(posXgyro)
    Dis2PreGyro(i) = sqrt((posXgyro(i)-posXgyro(i-1))^2+(posYgyro(i)-posYgyro(i-1))^2)/1000; %unit:km
    angle2PreGyro(i,1) = angleGyro(i)-angleGyro(i-1);  % unit:degree
end
%  Trans to GPS
for i=2:length(posXgyro)
    LatGyro(i,1) = asind(sind(Lat(i-1)).*cos(Dis2PreGyro(i)/R)+cosd(LatGyro(i-1)).*sin(Dis2PreGyro(i)/R).*cosd(-rem(angle2PreGyro(i)+180,360)))-0.000008-(i-1)/30000000;
    LonGyro(i,1) = Lon(i-1)+ atan2d(sind(-rem(angle2PreGyro(i)+180,360)).*sin(Dis2PreGyro(i)/R).*cosd(LatGyro(i-1)),(cos(Dis2PreGyro(i)/R)-(sind(Lat(i-1)).*sind(LatGyro(i)))));
end

end