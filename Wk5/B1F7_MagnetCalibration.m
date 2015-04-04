%% B1F7 function: Calibrate magnetometer
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F7 function: -1.Calibrate magnetometer
%                        -2.If MagnetCalibFactor=0, output normal constant
%                        -3.If MagnetCalibFactor=1, need recalibration
%   INPUT: MagnetCalibFactor
%          magnetX,magnetY,magnetZ
%  OUTPUT: magnetXCab,magnetYCab,magnetZCab

%% How to get special calibration data:
% rotate your phone in special configuration:
% 1. place phone flat: constant speed rotate 1 circle
% 2. Place phone vertically Y axis point upward: constant speed rotate 1
% circle
% 3. Place phone vertically X axis point upward: constant speed rotate 1
% circle

%% function
function [magnetXCab,magnetYCab,magnetZCab] = B1F7_MagnetCalibration(MagnetCalibFactor,magnetX,magnetY,magnetZ)
% find offset value for each axis
% Condition 1: No need for special calibration
if MagnetCalibFactor == 0
    magnetXoffset = -13.1888;
    magnetYoffset = 11.6191;
    magnetZoffset = 11.3490;
% Condition 2: Special calibration needed
else if MagnetCalibFactor == 1
    magnetXoffset = (magnetXmax + magnetXmin) / 2;
    magnetYoffset = (magnetYmax + magnetYmin) / 2;
    magnetZoffset = (magnetZmax + magnetZmin) / 2;
    end
end

% Resample the data: Delete offset
magnetXCab = magnetX - magnetXoffset;
magnetYCab = magnetY - magnetYoffset;
magnetZCab = magnetZ - magnetZoffset;
end