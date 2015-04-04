%% Wk 5 Rewrite and modularization
clear;close all;
%% Section 0: Read file
filename = '/wk5/2015-04-03_19-21-28.csv';
filelocation = ['/Users/lazysheep/Study/Thesis/sensor logging Raw files',filename];
T = readtable(filelocation);
%% Section 1: Rename all the input data from "SensorLog" App
%  Process file by "B1F1_HandleInputfile" function
[time,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magnetX,magnetY,magnetZ,XcodeTrueHeading,XcodeMagneticHeading,XcodeHeadingAccuracy]=B1F1_HandleInputfile(T);
%  Clear workspace
clearvars -except time accelX accelY accelZ gyroX gyroY gyroZ magnetX magnetY magnetZ XcodeTrueHeading XcodeMagneticHeading XcodeHeadingAccuracy;

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
%  MagnetCalibFactor: 0 Use Constant/ 1 Need Calibration
MagnetCalibFactor = 0;
[magnetXCab,magnetYCab,magnetZCab] = B1F7_MagnetCalibration(MagnetCalibFactor,magnetX,magnetY,magnetZ);

%% Section 8: Convert Yaw angle based on megnatometer ONLY