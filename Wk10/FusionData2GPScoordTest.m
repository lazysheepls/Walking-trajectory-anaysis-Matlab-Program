%% Plot path back to Google map: From posX2,posY2,angle2 for now
close all;
clearvars Dis2Origin;
LatNEW=Lat;LonNEW=Lon;
Dis2Origin=[0];  %Distance between 2 points
R=6370.8;

%% THIS WORKS!!!!!(Gyro+Compass trans to GPS Coord)
%  Prep for distance and angle
Dis2OriginNEW = zeros(length(posX2),1);
angleGG=zeros(length(posX2),1); %Angle between 2 points
SIZE=2;
for i=SIZE:SIZE:length(posX2)
    Dis2OriginNEW(i) = sqrt((posX2(i)-posX2(i-SIZE+1))^2+(posY2(i)-posY2(i-SIZE+1))^2)/1000; %unit:km
    angleGG(i,1) = angle2(i)-angle2(i-SIZE+1);  % unit:degree
end
%  Trans to GPS
figure(1);
% LatNEW=Lat;LonNEW=Lon;
for i=SIZE:SIZE:length(posX2)
    LatNEWNN(i,1) = asind(sind(Lat(i-SIZE+1)).*cos(Dis2OriginNEW(i)/R)+cos(Lat(i-SIZE+1)).*sin(Dis2OriginNEW(i)/R).*cosd(-rem(angleGG(i)+180,360)));
    LonNEWNN(i,1) = Lon(i-SIZE+1)+ atan2d(sind(-rem(angleGG(i)+180,360)).*sin(Dis2OriginNEW(i)/R).*cosd(Lat(1)),(cos(Dis2OriginNEW(i)/R)-(sind(Lat(i-SIZE+1)).*sind(LatNEWNN(i)))));
    hold on;
    plot(LonNEWNN(i),LatNEWNN(i),'.b','MarkerSize',20);
end
%% Fuse GPS coordninates in:
GPSSIZE=2;
alphaGPSFuse=0.2;
LatFuse=Lat; LonFuse=Lon;
for i=SIZE:SIZE:length(posX2)
    LatFuse(i)=alphaGPSFuse.*LatNEWNN(i)+(1-alphaGPSFuse).*Lat(i);
    LonFuse(i)=alphaGPSFuse.*LonNEWNN(i)+(1-alphaGPSFuse).*Lon(i);
    hold on;
    plot(LonFuse(i),LatFuse(i),'.c','MarkerSize',15);
end
%% Plot the diagram
% figure;plot(Dis2Origin)
hold on;
plot(Lon,Lat,'.r','MarkerSize',5)
% hold on;
% plot(LonNEW(1),LatNEW(1),'.r','MarkerSize',20)
% hold on;
% plot(LonNEW,LatNEW,'.c','MarkerSize',20)
% hold on;
% plot(LonNEW(1000),LatNEW(1000),'.r','MarkerSize',20)
hold on;
plot_google_map('MapType','satellite')
title('Fused Data: Compass+Gyro Path vs +GPS Fuse');