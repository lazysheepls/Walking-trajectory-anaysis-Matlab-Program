%% B1F7 function: Calibrate magnetometer
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F8 function: 1.Convert magnetometer calibrated data into Yaw angle
%                        2.Use XcodeTrueHeading as reference
%   INPUT: time
%          magnetXCab,magnetYCab,magnetZCab,PitchAccel,RollAccel
%  OUTPUT: magnetHeading

%% Function

function [magnetHeading] = B1F8_MagnetConvertHeading(time,magnetXCab,magnetYCab,magnetZCab,PitchAccel,RollAccel,XcodeMagneticHeading,XcodeTrueHeading)
% Add tilt compenstation from Roll and Pitch angle form Accel
Xh = magnetXCab .* cosd(PitchAccel) + magnetZCab .* sind(PitchAccel);
Yh = magnetXCab .* sind(RollAccel).*sind(PitchAccel) + magnetYCab .* cosd(RollAccel) - magnetZCab .* sind(RollAccel) .* cosd(PitchAccel);

% Calculate magnetometer heading
magnetHeading = atan2d(Yh,Xh);
% Compensate magnet declination from:  http://magnetic-declination.com/
declination = 12.33;
% iphone special 
headingOffset = 87;     %special offset for iphone
magnetHeading = magnetHeading + declination - headingOffset;
for n=1:length(magnetHeading)
if magnetHeading(n,1) < 0
    magnetHeading(n,1) = magnetHeading(n,1) + 360;
elseif magnetHeading(n,1) > 360
    magnetHeading(n,1) = magnetHeading(n,1) - 360;
elseif Xh(n)==0 && Yh(n)<0
    magnetHeading(n,1)=90;    
elseif Xh(n)==0 && Yh(n)>0
    magnetHeading(n,1)=270; 
end
end
%% Plot diagram
figure;
plot(time,XcodeMagneticHeading,'r');
hold on;
plot(time,XcodeTrueHeading,'b');
grid on;
title('Magnetometer Calibrated Angle data converted from Raw Compared with Xcode');
xlabel('time(s)');
hold on;
plot(time,magnetHeading);
hold off;
legend('XcodeMagneticHeading','XCodeTrueHeading','matlabMagneticHeading');

figure;
plot(time,magnetHeading,'b');
grid on;
title('Magnetometer Calibrated Angle data converted from Raw');
xlabel('time(s)');
ylabel('Angle(degree)');
legend('Heading');
end