%%  Data Fusion Testing: Import compass data into all April 27th
%   To run this program:
%   - 1. Run B1_Rewrite.m
%   - 2. Run FindStepsTest.m
%   Currently: Use Xcode TrueHeading data,direct outcome from
%   FindStepsTest.m(accurate data)

%% Make the path more precise: use all data and the estimated speed
close all;
figure;
plot(pathX,pathY);
hold on;
quiver(pathX,pathY,vx,vy,0.2);
title('Path: Consider the angle: GyroYaw angle(More precise)');
xlabel('X(m)');
ylabel('Y(m)');
axis equal;

%% Init Setting
%  Resize the compass heading = pathX size
PathHeading = XcodeTrueHeading((length(XcodeTrueHeading)-length(pathX)+1):length(XcodeTrueHeading));
w = 0.95;   % Weight
CurBearing = gyroStep;
CurBearing(1) = PathHeading(1);

CurBearing = PathHeading;
for n=2:20:length(pathX)
%     CurBearing(n,1)= w*PathHeading(n) + (1-w)*gyroStep(n);
%     difference = PathHeading(n)-gyroStep(n);
%     CurBearing(n:length(CurBearing)) = CurBearing(n:length(CurBearing)) - difference;
end
vx = cosd(CurBearing);
vy = sind(CurBearing);
for n=2:length(gyroStep)
    pathX_add(n,1)= speed.*timeInt.*cosd(CurBearing(n))+pathX(n-1,1);
    pathY_add(n,1)= speed.*timeInt.*sind(CurBearing(n))+pathY(n-1,1);
end

figure;
plot(pathX_add,pathY_add,'r');
% hold on;
% quiver(pathX_add,pathY_add,vx,vy,0.2);
title('Path: Add compass heading angles');
xlabel('X(m)');
ylabel('Y(m)');
axis equal;