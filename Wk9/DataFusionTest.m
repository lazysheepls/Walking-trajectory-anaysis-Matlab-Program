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
alphaAngle = 0.9;
alphaGPS = 0.1;
GPSDistance = zeros(length(Lat1),1);
GPSDistanceX = zeros(length(Lat1),1);
GPSDistanceY = zeros(length(Lat1),1);
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
    if rem(i,5)==0  % remainder
        angle2(i) = (1-alphaAngle).*angle2(i) + alphaAngle.*XcodeTrueHeading(i);
        angle3(i) = angle2(i);
    end
    % Update stage: Fuse GPS position in:
    R = 6370.8;  % Earth Radius(km)
    GPSFuseSize = 30;
    if rem(i,GPSFuseSize)==0
%         dlon = Lon(i) - Lon(i-GPSFuseSize+1); 
%         dlat = Lat(i) - Lat(i-GPSFuseSize+1); 
%         a = (sind(dlat/2))^2 + cosd(Lat(i-GPSFuseSize+1)) * cosd(Lat(i)) * (sind(dlon/2))^2; 
%         c = 2 * atan2( sqrt(a), sqrt(1-a) ) 
%         d = R * c * 1000; % Distance:Unit:m(where R is the radius of the Earth)
    end
end 

figure;
plot(posX1,posY1,'r');
hold on;
plot(posX2,posY2,'b','Linewidth',4);
hold on;
plot(posX3,posY3,'c','Linewidth',2);
axis equal
hold on;
% plot(posX1(1),posY1(1),'*r')

%% Plot path back to Google map:
Lat1=Lat;Lon1=Lon;
d1=zeros(length(Lat1),1);  %Distance between 2 points
Long1Change1=zeros(length(Lat1),1);
for i=2:length(Lat1)

end

figure;
% plot(Lon,Lat,'.r','MarkerSize',20)
% hold on;
plot(Lon1,Lat1,'.b','MarkerSize',20)
hold on;
plot_google_map('MapType','satellite');