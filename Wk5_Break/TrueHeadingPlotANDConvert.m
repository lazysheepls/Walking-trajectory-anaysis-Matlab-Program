%% wk5 break
%  Plot magnetomter in polar form and convert to North South angle
%  Try to figure out how to deal with the magnetometer heading data

%%
close all;
%  Plot heading data in the original form
figure;
plot(time,XcodeTrueHeading,'b');
grid on;
title('Magnetometer Calibrated Angle data converted from Raw Compared with Xcode');
xlabel('time(s)');
hold on;
plot(time,magnetHeading);
hold off;
legend('XCodeTrueHeading','matlabMagneticHeading');

%  Try polar plot
figure;
angle=XcodeTrueHeading./180.*pi; 
polar(angle,time)
title('True Heading from Xcode');

%% Plot the path based on magnet heading only
%  Find steps
[pks,locs,widths,proms]  = findpeaks(RollAccel,'MinPeakProminence',3);
clearvars gaps;
for n=1:(length(locs)-1)
    gaps(n,1) = time(locs(n+1))-time(locs(n));
end
timeGap = median(gaps);
k=1;
while gaps(k,1)<(timeGap*2)
k=k+1;
end
for n=1:k
    locs(1,:)=[];   % Delete that row if too far away from other steps
    pks(1,:)=[];  
end
figure;
plot(time,RollAccel,'b');
hold on
plot(time(locs),RollAccel(locs),'or');
title('Accel Roll angle: Determine steps');
xlabel('time(sec)');
ylabel('Angle(degree)');
%  Find avg speed
steps = length(pks);
stepSize=0.65;  %65cm
timeStep = time(locs);
speed = stepSize/timeGap;     % unit: m/s
path = stepSize;
for n=2:length(timeStep)
    path(n,1)=path(n-1,1)+stepSize;
end

%% Magnet Trueheading arrows
magnetStep = XcodeTrueHeading(locs);
mx = cosd(magnetStep);
my = sind(magnetStep);

pathX = path .* mx;
pathY = path .* my;
figure;
plot(pathX,pathY);
axis equal; 
hold on;
quiver(pathX,pathY,mx,my,0.2);    % Magnet heading angle
title('Path: Do not consider the angle');
xlabel('X(m)');
ylabel('Y(m)');

