%% Wk 5 Rewrite and modularization
clear;close all;
%% Section 0: Read file
% 2015-04-08_23-15-30.csv
% 2015-04-08_23-16-01.csv
filename = '/wk5_Break/2015-04-08_23-15-30.csv';
filelocation = ['/Users/lazysheep/Study/Thesis/sensor logging Raw files',filename];
T = readtable(filelocation);
% MagnetCalibFactor: 1: 1st set data,need to generate parameters  2:2ns set of data, use the parameters
MagnetCalibFactor = 1;
%% Section 1: Rename all the input data from "SensorLog" App
%  Process file by "B1F1_HandleInputfile" function
[time,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magnetX,magnetY,magnetZ,XcodeTrueHeading,XcodeMagneticHeading,XcodeHeadingAccuracy]=B1F1_HandleInputfile(T);
%  Clear workspace
clearvars T;
%% Section 2: Plot raw data
B1F2_PlotRawData(time,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magnetX,magnetY,magnetZ,XcodeTrueHeading,XcodeMagneticHeading);

%% Section 3: Accelerometer raw data noise filtering
[accelXft,accelYft,accelZft] = B1F3_FilterNoiseAccelData(time,accelX,accelY,accelZ);

%% Section 4: Gyroscope raw data noise filtering and elminate bias&shift
[gyroXft,gyroYft,gyroZft] = B1F4_FilterNoiseGyroData(time,gyroX,gyroY,gyroZ);

%% Section 5: Convert Roll & Pitch angle based on acceletometer ONLY
[RollAccel,PitchAccel] = B1F5_AccelConvertRollPitch(time,accelXft,accelYft,accelZft);

%% Section 6: Convert Roll Pitch & Yaw angle based on gyroscope ONLY
[RollGyro,PitchGyro,YawGyro] = B1F6_GyroConvertRollPitchYaw(time,gyroXft,gyroYft,gyroZft);

%% Section 7: Magnetometer Calibration
if MagnetCalibFactor ==1
e_center=0;
e_radii=0;
e_eigenvecs=0;
e_algebraic=0;
[magnetXCab,magnetYCab,magnetZCab,e_center,e_radii,e_eigenvecs,e_algebraic] = B1F7_MagnetCalibration(MagnetCalibFactor,magnetX,magnetY,magnetZ,e_center,e_radii,e_eigenvecs,e_algebraic);
save('MagnetTempCalib','e_center','e_radii','e_eigenvecs','e_algebraic');
elseif MagnetCalibFactor ==2
load('MagnetTempCalib');
[magnetXCab,magnetYCab,magnetZCab,e_center,e_radii,e_eigenvecs,e_algebraic] = B1F7_MagnetCalibration(MagnetCalibFactor,magnetX,magnetY,magnetZ,e_center,e_radii,e_eigenvecs,e_algebraic);
end

%% Section 8: Convert to heading based on megnatometer ONLY
[magnetHeading] = B1F8_MagnetConvertHeading(time,magnetXCab,magnetYCab,magnetZCab,PitchAccel,RollAccel,XcodeMagneticHeading,XcodeTrueHeading);

%% Now We could either use magnetHeading/ XcodeTruHeading