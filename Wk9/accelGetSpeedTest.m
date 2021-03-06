close all;
%% Method 1: Direct calculation from accelX, accelY
magnitude = sqrt(accelX.^2+accelY.^2);
numSign = accelX.*accelY;
denSign = abs(accelX).*abs(accelY);
accelSign = numSign./denSign;
accelXY = magnitude .* accelSign;
accelSpeed = [0];
timeInt = time(2)-time(1);
for i=1:length(accelX)
    accelSpeed = [accelSpeed; accelSpeed(i)+accelXY(i)*timeInt];
end
figure;
plot(GPSspeed,'b');
hold on;
plot(-accelSpeed,'r');
legend('GPS speed','Accel XY combined speed');
title('Accel speed: Method 1');
% Conclusion: Result is terrible, even I have already consider the sign
% from accel, still it is not good at all. Accumulation should not work.
% Same problem: Drift away,error accumalted

%% Method 2: Step Length/Speed Estimation from 146433.pdf
% Double integral method: Theoretically
% Step length = Integral(V dt) = Integral(Integral(a dt))
% WHY YOU CANNOT USE THIS METHOD: Drift away, PLS SEE oneNote for details

%% Method 3: Step based average accelration for each step
%  You need to run B1_rewrite first
[pksUP,locsUP,widthsUP,promsUP]  = findpeaks(RollAccel,'MinPeakProminence',3);
[pksDOWN,locsDOWN,widthsDOWN,promsDOWN]  = findpeaks(-RollAccel,'MinPeakProminence',3);
if length(locsUP)>length(locsDOWN) %locsUP longer than locsDOWN
    locsUP = locsUP((length(locsUP)-length(locsDOWN)+1):length(locsUP));
else                               %locsDOWN longer than locsUP
    locsDOWN = locsDOWN((length(locsDOWN)-length(locsUP)+1):length(locsDown));
end

% Average the accelration for each step
magnitude = sqrt(accelX.^2+accelY.^2);
numSign = accelX.*accelY;
denSign = abs(accelX).*abs(accelY);
accelSign = numSign./denSign;
accelXY = magnitude .* accelSign;
accelXYavg = (accelXY(locsUP)+accelXY(locsDOWN))./2;

figure;
plot(time,accelXY,'b');
hold on;plot(time(locsUP),accelXYavg,'r');
title('XY plane average acceleration');
xlabel('time');ylabel('Unit:m/s^2');
axis([0 max(time) -2 2]);grid on;
legend('Real time accelration','Average acceleration');

% Calculate speed from acceleration
accelSpeed = [0];
timeInt = time(2)-time(1);
for i=1:length(stepGaps)
    accelSpeed = [accelSpeed;accelSpeed(i)+accelXYavg(i).*stepGaps(i)];
end
figure;
plot(time(locsUP),-accelSpeed);
hold on; plot(time,GPSspeed);
title('XY plane speed from accleration:NOT WORKING');
xlabel('time');ylabel('Unit:m/s');
grid on;
legend('Speed calculated from accelration average');
