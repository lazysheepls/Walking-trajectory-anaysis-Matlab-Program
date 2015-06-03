function [posXFuseCmp,posYFuseCmp,angleFuseCmp,LonFuseCmp,LatFuseCmp] = B1F13_DataFusionPlusCompass(CmpFuseMode,CmpFuseSize,CmpFuseAlpha,posXFuseCmp,posYFuseCmp,angleFuseCmp,walkspeed,XcodeTrueHeading,magnetHeading,time,Lon,Lat,R)
% Set heading mode
if CmpFuseMode==1
    compassHeading = XcodeTrueHeading;
else
    compassHeading = magnetHeading;
end
% initial setting: Set same as Gyro
posXFuseCmp = posXFuseCmp;
posYFuseCmp =posYFuseCmp;
angleFuseCmp = angleFuseCmp;
deltaT = (time(2)-time(1)).*CmpFuseSize;
% Prepare angle data
for i=CmpFuseSize+1:length(angleFuseCmp)
    angleFuseCmp(i) = (1-CmpFuseAlpha).*angleFuseCmp(i)+CmpFuseAlpha.*compassHeading(i);
end
% Fuse compass angle in
for i=(CmpFuseSize+1):CmpFuseSize:length(posXFuseCmp)
    posXFuseCmp(i) = posXFuseCmp(i-CmpFuseSize) + deltaT.*walkspeed(i).*cosd(angleFuseCmp(i-CmpFuseSize));
    posYFuseCmp(i) = posYFuseCmp(i-CmpFuseSize) + deltaT.*walkspeed(i).*sind(angleFuseCmp(i-CmpFuseSize));
end

% Convert to GPS coordniate
LonFuseCmp=Lon;
LatFuseCmp=Lat;

%  Prep for distance and angle
Dis2PreFCmp = zeros(length(posXFuseCmp),1);
angle2PreFCmp=zeros(length(posXFuseCmp),1); %Angle between 2 points
for i=CmpFuseSize+1:CmpFuseSize:length(posXFuseCmp)
    Dis2PreFCmp(i) = sqrt((posXFuseCmp(i)-posXFuseCmp(i-CmpFuseSize))^2+(posYFuseCmp(i)-posYFuseCmp(i-CmpFuseSize))^2)/1000; %unit:km
    angle2PreFCmp(i,1) = angleFuseCmp(i)-angleFuseCmp(i-CmpFuseSize);  % unit:degree
end
%  Trans to GPS
for i=CmpFuseSize+1:CmpFuseSize:length(posXFuseCmp)
    LatFuseCmp(i,1) = asind(sind(Lat(i-CmpFuseSize)).*cos(Dis2PreFCmp(i)/R)+cos(Lat(i-CmpFuseSize)).*sin(Dis2PreFCmp(i)/R).*cosd(-rem(angle2PreFCmp(i)+180,360)))-0.000002-(i-1)/100000000;
    LonFuseCmp(i,1) = Lon(i-CmpFuseSize)+ atan2d(sind(-rem(angle2PreFCmp(i)+180,360)).*sin(Dis2PreFCmp(i)/R).*cosd(Lat(i-CmpFuseSize)),(cos(Dis2PreFCmp(i)/R)-(sind(Lat(i-CmpFuseSize)).*sind(Lat(i)))));
end
end