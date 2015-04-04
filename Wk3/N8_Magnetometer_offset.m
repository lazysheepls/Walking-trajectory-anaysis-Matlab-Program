%% wk3
% This program is used for magnetometer calibration for the first time
% To use this program: rotate your phone in special configuration
% 1. place phone flat: constant speed rotate 1 circle
% 2. Place phone vertically Y axis point upward: constant speed rotate 1
% circle
% 3. Place phone vertically X axis point upward: constant speed rotate 1
% circle
% Input: Magnetometer: locationHeadingX, locationHeadingY, locationHeadingZ
%                      locationMagneticHeading, locationTrueHeading
% Input: acclerometer filtered angles: PitchAccel, RollAccel, time
% Output: Xh , Yh, heading angle
% How to use in normal program
% use the wk3 program to grab the offset value then use to other program
close all;
figure;
plot(time, magnetX,'r');
hold on;
plot(time, magnetY,'b');
hold on;
plot(time, magnetZ,'m');
hold off;
grid on;
legend('X','Y','Z');
xlabel('time(s)');
ylabel('Magnetic Strength(uT)');
title('Magnetometer Raw data for calibration');

figure;
plot(time,XcodeMagneticHeading,'r');
hold on;
plot(time,XcodeTrueHeading,'b');
grid on;
title('Magnetometer Calibrated Angle data converted from Raw Compared with Xcode');
xlabel('time(s)');


%% calibration
% 1. Find max / min for each axis(1st time only)
% magnetXmax = max(locationHeadingX);
% magnetXmin = min(locationHeadingX);
% 
% magnetYmax = max(locationHeadingY);
% magnetYmin = min(locationHeadingY);
% 
% magnetZmax = max(locationHeadingZ);
% magnetZmin = min(locationHeadingZ);

% 2. find offset value for each axis
% The following data are from the calib file in wk 3
magnetXoffset = -13.1888;
magnetYoffset = 11.6191;
magnetZoffset = 11.3490;
% Calculation of the offset value(1st time only)
% magnetXoffset = (magnetXmax + magnetXmin) / 2;
% magnetYoffset = (magnetYmax + magnetYmin) / 2;
% magnetZoffset = (magnetZmax + magnetZmin) / 2;

% 3.Raw data - offset to resample the data
magnetXCab = magnetX - magnetXoffset;
magnetYCab = magnetY - magnetYoffset;
magnetZCab = magnetZ - magnetZoffset;

% 4. Use accel Pitch and Roll angle from accelrometer to get the Ref heading
Xh = magnetXCab .* cosd(PitchAccel) + magnetYCab .* sind(RollAccel).*sind(PitchAccel) - magnetZCab .* cosd(RollAccel) .* sind(PitchAccel);
Yh = magnetYCab .* cosd(RollAccel) + magnetZCab .* sind(PitchAccel);


% 5. Calculate Megnetic angle based on 
for n=1:length(time)
if Xh(n)<0
    magnetAngle(n,1)=180-atand(Yh(n)./Xh(n));
elseif Xh(n)>0 && Yh(n)<0
    magnetAngle(n,1)=-atand(Yh(n)./Xh(n));
elseif Xh(n)>0 && Yh(n)>0
    magnetAngle(n,1)=360-atand(Yh(n)./Xh(n));
elseif Xh(n)==0 && Yh(n)<0
    magnetAngle(n,1)=90;    
elseif Xh(n)==0 && Yh(n)>0
    magnetAngle(n,1)=270; 
end
end
% test2 =-atan2(locationHeadingY,locationHeadingX).*180./pi;
hold on;
plot(time,magnetAngle,'c');
hold off;
legend('XcodeMagneticHeading','XCodeTrueHeading','matlabMagneticHeading');

figure;
plot(time,magnetAngle,'r');
grid on;
title('Magnetometer Calibrated Angle data converted from Raw');
xlabel('time(s)');
ylabel('Angle(degree)');
legend('Heading');