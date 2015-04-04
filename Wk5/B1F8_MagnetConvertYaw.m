%% B1F7 function: Calibrate magnetometer
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F7 function: -1.Calibrate magnetometer
%                        -2.If MagnetCalibFactor=0, output normal constant
%                        -3.If MagnetCalibFactor=1, need recalibration
%   INPUT: time
%          magnetXCab,magnetYCab,magnetZCab
%  OUTPUT: magnetYaw

%% Function

% 4. Use accel Pitch and Roll angle from accelrometer to get the Ref heading
Xh = magnetX .* cos(PitchAccel.*pi./180) + magnetY .* sin(RollAccel.*pi./180).*sin(PitchAccel.*pi./180) - magnetZ .* cos(RollAccel.*pi./180) .* sin(PitchAccel.*pi./180);
Yh = magnetY .* cos(RollAccel.*pi./180) + magnetZ .* sin(PitchAccel.*pi./180);


% 5. Calculate Megnetic angle based on 
for n=1:length(time)
if Xh(n)<0
    magnetYaw(n,1)=180-atan(Yh(n)./Xh(n)).*180./pi;
elseif Xh(n)>0 && Yh(n)<0
    magnetYaw(n,1)=-atan(Yh(n)./Xh(n)).*180./pi;
elseif Xh(n)>0 && Yh(n)>0
    magnetYaw(n,1)=360-atan(Yh(n)./Xh(n)).*180./pi;
elseif Xh(n)==0 && Yh(n)<0
    magnetYaw(n,1)=90;    
elseif Xh(n)==0 && Yh(n)>0
    magnetYaw(n,1)=270; 
end
end
% test2 =-atan2(locationHeadingY,locationHeadingX).*180./pi;
hold on;
plot(time,magnetYaw,'c');
hold off;
legend('XcodeMagneticHeading','XCodeTrueHeading','matlabMagneticHeading');

figure;
plot(time,magnetYaw,'r');
grid on;
title('Magnetometer Calibrated Angle data converted from Raw');
xlabel('time(s)');
ylabel('Angle(degree)');
legend('Heading');