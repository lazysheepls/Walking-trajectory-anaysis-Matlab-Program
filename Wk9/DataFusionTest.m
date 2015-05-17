%% Data fusion base:
%  Gyro as based  angle
%  GPSspeed/stepSpeed as x,y position base
close all;
deltaT=time(2)-time(1);
posX1=[0];posY1=[0];    % Gyro Only
posX2=[0];posY2=[0];    % Gyro+Compass
posX3=[0];posY3=[0];    % Gyro+Compass+GPS
Lat1=[0];Long1=[0];    % Gyro(Lat+Long)
angle1 = YawGyroCalib;angle2 = YawGyroCalib;angle3 = YawGyroCalib;
alphaAngle = 0.7;
alphaGPS = 0.1;
GPSDistance = zeros(length(Lat1),1);
GPSDistanceX = zeros(length(Lat1),1);
GPSDistanceY = zeros(length(Lat1),1);
distance=[0];k=2;
for i=2:length(time)
    % Only gyro
    posX1(i) = posX1(i-1) + deltaT.*GPSspeed(i).*cosd(angle1(i-1));
    posY1(i) = posY1(i-1) + deltaT.*GPSspeed(i).*sind(angle1(i-1));
    angle1(i) = YawGyroCalib(i);
    
    % Gyro + Compass angle
    posX2(i) = posX2(i-1) + deltaT.*GPSspeed(i).*cosd(angle2(i-1));
    posY2(i) = posY2(i-1) + deltaT.*GPSspeed(i).*sind(angle2(i-1));
    angle2(i) = YawGyroCalib(i);
    % Prep for GPS updating
    posX3(i) = posX2(i);posY3(i) = posY2(i);angle3(i) = angle2(i);
    % Update stage: Fuse Compass angle in:
    if rem(i,1)==0  % remainder
        angle2(i) = (1-alphaAngle).*angle2(i) + alphaAngle.*XcodeTrueHeading(i);
        angle3(i) = angle2(i);
    end
    % Update stage: Fuse GPS position in:
    R = 6370.8;  % Earth Radius(km)
    GPSFuseSize = 30;
    if rem(i,GPSFuseSize)==0
%         dlon = Lon(i) - Lon(i-GPSfusionSize+1); 
%         dlat = Lat(i) - Lat(i-GPSfusionSize+1); 
%         a = (sind(dlat/2))^2 + cosd(Lat(i-GPSfusionSize+1)) * cosd(Lat(i)) * (sind(dlon/2))^2; 
%         c = 2 * atan2( sqrt(a), sqrt(1-a)) ;
%         d = R * c * 1000; % Distance:Unit:m(where R is the radius of the Earth)
%         distance(k,1) = d+distance(k-1);
%         k=k+1;
    end
end

% plot angle fusion result: Gyro + compass
figure;
plot(time,GPScourse);hold on;
plot(time,XcodeTrueHeading,'r');hold on;
plot(time,YawGyroCalib,'b');hold on;
plot(time,angle2,'c');
title('Heading Comparison');
xlabel('Time(s)');ylabel('Degree');
legend('GPS Course','Compass Heading','Gyro Yaw angle','Fused angle');

% plot path fusion result: Gyro + compass
figure;
plot(posY1,posX1,'r');
hold on;
plot(posY2,posX2,'b','Linewidth',1);
% hold on;
% plot(posX3,posY3,'c','Linewidth',2);
axis equal
hold on;
plot(posY1(1),posX1(1),'*r');
xlabel('PositionY');ylabel('PositionX');
legend('Path based on Gyro','Path based on fused data');
title('Path Comparison');

%% Plot path back to Google map: From posX2,posY2,angle2 for now
% Testing on FusionData2GPScoord.m in wk10 folder