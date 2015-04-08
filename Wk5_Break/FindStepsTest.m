%% Tue. April 7th: Start poltting path Wk5 Break
%  This section is testing walking trajectory with phone held  flat
close all;

%%
%  Find steps
[pksY,locsY,widthsY,promsY]  = findpeaks(accelYft,'MinPeakProminence',0.1);
[pksZ,locsZ,widthsZ,promsZ]  = findpeaks(accelZft,'MinPeakProminence',0.1);
[pks,locs,widths,proms]  = findpeaks(RollAccel,'MinPeakProminence',3);
figure;
plot(time,RollAccel,'b');
hold on
plot(time(locs),RollAccel(locs),'or');
title('Accel Roll angle: Determine steps');
xlabel('time(sec)');
ylabel('Angle(degree)');

steps = length(pks);
%% Find avg gap time between each step and to estimate speed
% By default step size
stepSize=0.65;  %65cm
clearvars gap;
gaps(1)=time(locs(2))-time(locs(1));
for n=2:length(locs)
    gaps(n,1) = time(locs(n))-time(locs(n-1));
end
% Find average time interval
timeGap = mean(gaps);
% timeStep = time(locs(1):length(time));
timeStep = time(locs);
% Find speed
speed = stepSize/timeGap;     % unit: m/s
path = stepSize;
for n=2:length(timeStep)
    path(n,1)=path(n-1,1)+stepSize;
end

%% Plot ONLY stright line path (x,y)
% comet(time,RollAccel,0.0583);  % later for animation
gyroStep=zeros(length(locs),1);
vx = cosd(gyroStep);
vy = sind(gyroStep);
pathX = path .* vx;
pathY = path .* vy;
figure;
plot(pathX,pathY);
axis equal; 
hold on;
gyroStep = YawGyro(locs);
vx = cosd(gyroStep);
vy = sind(gyroStep);
quiver(pathX,pathY,vx,vy,0.2);
title('Path: Do not consider the angle');
xlabel('X(m)');
ylabel('Y(m)');

%% Try to plot the real path based on gyro angle: with only each step data
figure;
pathX(1)= stepSize.*cosd(gyroStep(1));
pathY(1)= stepSize.*sind(gyroStep(1));
for n=2:length(path)
    pathX(n,1)= stepSize.*cosd(gyroStep(n))+pathX(n-1,1);
    pathY(n,1)= stepSize.*sind(gyroStep(n))+pathY(n-1,1);
end
plot(pathX,pathY);
hold on;
quiver(pathX,pathY,vx,vy,0.2);
title('Path: Consider the angle: GyroYaw angle(Roughly)');
xlabel('X(m)');
ylabel('Y(m)');

%% Make the path more precise: use all data and the estimated speed
figure;
gyroStep= YawGyro(locs:length(YawGyro));
vx = cosd(gyroStep);
vy = sind(gyroStep);
pathX(1)= stepSize.*cosd(gyroStep(1));
pathY(1)= stepSize.*sind(gyroStep(1));
timeInt = time(2)-time(1);
for n=2:length(gyroStep)
    pathX(n,1)= speed.*timeInt.*cosd(gyroStep(n))+pathX(n-1,1);
    pathY(n,1)= speed.*timeInt.*sind(gyroStep(n))+pathY(n-1,1);
end
plot(pathX,pathY);
hold on;
quiver(pathX,pathY,vx,vy,0.2);
title('Path: Consider the angle: GyroYaw angle(More precise)');
xlabel('X(m)');
ylabel('Y(m)');

%% 