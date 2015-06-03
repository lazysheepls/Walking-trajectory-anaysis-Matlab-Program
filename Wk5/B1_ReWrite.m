%% Wk 5 Rewrite and modularization
clearvars -except shiftX shiftY shiftZ;
close all;
%% Section 0: Read file
% Set 1: wk9:Gyro has wired shift problem
% 2015-05-03_01-20-07.csv
% 2015-05-03_01-20-43.csv
% Set 3: wk10/set3 super flat surface(Good)
% 2015-05-12_15-51-51.csv
% 2015-05-12_15-52-28.csv
% 2015-05-12_15-52-43.csv
% Set 6: wk10/set 6 super flat(Good)
% 2015-05-12_17-05-59.csv
% 2015-05-12_17-06-36.csv
% 2015-05-12_17-06-51.csv
% Set 7: wk10/set 7 super flat(Na....Still Drifting BUT I add calib factor)
% 2015-05-12_17-08-07.csv
% 2015-05-12_17-08-34.csv
% 2015-05-12_17-08-57.csv
% Set 8: Long distance walk
% 2015-05-21_13-10-33.csv
% 2015-05-21_13-10-50.csv
% 2015-05-21_13-11-03.csv
filename = '/wk11/LongDistance2/2015-05-21_13-11-03.csv'; 
filelocation = ['/Users/lazysheep/Study/Thesis/sensor logging Raw files',filename];
T = readtable(filelocation);
% CalibFactor: 1: Calib gyro(place on flat surface)  
%              2: Calib Compass: rotate phone around
%              3: Calib Fin: Analysis data
CalibFactor = 3;
% GPS API Key activation Factor: 1:Connect with API for the first time 2:No need to activate
StaticMapAPIkeyFactor = 2;
%% Section 1: Rename all the input data from "SensorLog" App
%  Process file by "B1F1_HandleInputfile" function
[time,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magnetX,magnetY,magnetZ,XcodeTrueHeading,XcodeMagneticHeading,XcodeHeadingAccuracy,Lat,Lon,GPSspeed,GPScourse]=B1F1_HandleInputfile(T);
%  Clear workspace
clearvars T;
%% Section 2: Plot raw data
B1F2_PlotRawData(time,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magnetX,magnetY,magnetZ,XcodeTrueHeading,XcodeMagneticHeading);

%% Section 3: Accelerometer raw data noise filtering
[accelXft,accelYft,accelZft] = B1F3_FilterNoiseAccelData(time,accelX,accelY,accelZ);

%% Section 4: Gyroscope raw data noise filtering and elminate bias&shift
if CalibFactor==1
shiftX=0;shiftY=0;shiftZ=0;
    [gyroXft,gyroYft,gyroZft,shiftX,shiftY,shiftZ] = B1F4_FilterNoiseGyroData(time,gyroX,gyroY,gyroZ,shiftX,shiftY,shiftZ,CalibFactor);
else
    [gyroXft,gyroYft,gyroZft,shiftX,shiftY,shiftZ] = B1F4_FilterNoiseGyroData(time,gyroX,gyroY,gyroZ,shiftX,shiftY,shiftZ,CalibFactor);
end

%% Section 5: Convert Roll Pitch & Yaw angle based on gyroscope ONLY

[RollGyro,PitchGyro,YawGyro] = B1F5_GyroConvertRollPitchYaw(time,gyroXft,gyroYft,gyroZft);

%  The following program will not run during the gyro calib process
%  process(CalibFactor=1)
if CalibFactor==1
    return;     % program terminated
end

%% Section 6: Convert Roll & Pitch angle based on acceletometer ONLY
[RollAccel,PitchAccel] = B1F6_AccelConvertRollPitch(time,accelXft,accelYft,accelZft);
%% Section 7: Magnetometer Calibration
if CalibFactor ==2
e_center=0;
e_radii=0;
e_eigenvecs=0;
e_algebraic=0;
[magnetXCab,magnetYCab,magnetZCab,e_center,e_radii,e_eigenvecs,e_algebraic] = B1F7_MagnetCalibration(CalibFactor,magnetX,magnetY,magnetZ,e_center,e_radii,e_eigenvecs,e_algebraic);
save('MagnetTempCalib','e_center','e_radii','e_eigenvecs','e_algebraic');
elseif CalibFactor ==3
load('MagnetTempCalib');
[magnetXCab,magnetYCab,magnetZCab,e_center,e_radii,e_eigenvecs,e_algebraic] = B1F7_MagnetCalibration(CalibFactor,magnetX,magnetY,magnetZ,e_center,e_radii,e_eigenvecs,e_algebraic);
end

%% Section 8: Convert to heading angles based on megnatometer ONLY
% With accelrometer angle compensation tech
[magnetHeading] = B1F8_MagnetConvertHeading(time,magnetXCab,magnetYCab,magnetZCab,PitchAccel,RollAccel,XcodeMagneticHeading,XcodeTrueHeading);
% Now We could either use magnetHeading/ XcodeTruHeading(XcodeTureHeading is still more accurate)

%% Section 8+: Before data fusion
%  The following program will not run during the magnet calibration
%  process(CalibFactor=2)
if CalibFactor==2
    return;     % program terminated
end

%  For the first time only: Google map static API need to be connected with
%  API key. After that, no key is needed.(StaticMapAPIkeyFactor=1)
if StaticMapAPIkeyFactor==1
%   API key: AIzaSyBCA_bJ4J52eNG1pOcih3JxMXnxkIZsrI4
    plot_google_map('APIKey','AIzaSyBCA_bJ4J52eNG1pOcih3JxMXnxkIZsrI4')
end

%% Section 9: Find Steps from accel Roll angles
[stepPks,stepLocs,stepGaps,stepNo,stepAvgGaptime] = B1F9_FindStepsFromAccelRoll(time,RollAccel);

%% Section 10: Gyro Yaw angle recalibrated before datafusion 
%calibration to fit with magnet and GPS course angle coordiante
[YawGyroCalib,InitHeading] = B1F10_YawGyroRecalib(XcodeTrueHeading,GPScourse,YawGyro,time);

%% Section 11: Speed calculation and selection before data fusion
%  Outcome 3 type of speed: 1. GPS speed mode
%                           2. Average speed per step mode(NOTE: NOT Pedometer)
%                           3. Accel speed mode(**NOTE:Not available**Check accelGetSpeedTest.m**)

stepSize = 0.7;  % 65cm fixed for now
[GPSspeed,stepSpeed] = B1F11_SpeedModeSelection(GPSspeed,accelX,accelY,time,stepLocs,stepGaps,stepSize);

%% Section 12: DataFusionBaseGyro
%  Gyro as base data, running at the highest frequency(30Hz).
%  Output distance and GPS coordinate.
%  Speed Mode: 1. stepSpeed(estimated step Size)
%              2. GPSspeed (measured by GPS vary a lot)
%  R: Radius of the earth(km)
speedMode = 2;
R = 6370.8;
[posXgyro,posYgyro,angleGyro,walkspeed,LonGyro,LatGyro] = B1F12_DataFusionBaseGyro(GPSspeed,stepSpeed,speedMode,YawGyroCalib,time,Lat,Lon,R);

%% Section 13: DataFusionGyro+Compass
% DataFusion: Gyro run as the highest frequency(30Hz)
% So compass run at about(15-20HZ), 15Hz as default(2times)
% Compass Fuse Mode: 1.use XcodeTrueHeading
%                    2.use magnetHeading
CmpFuseMode = 1;
CmpFuseSize = 2; %1:30Hz(only plot every 2 data) 2:15Hz(special plot required)
CmpFuseAlpha = 0.8; % alpha weight
[posXFuseCmp,posYFuseCmp,angleFuseCmp,LonFuseCmp,LatFuseCmp] = B1F13_DataFusionPlusCompass(CmpFuseMode,CmpFuseSize,CmpFuseAlpha,posXgyro,posYgyro,angleGyro,walkspeed,XcodeTrueHeading,magnetHeading,time,Lon,Lat,R);
% Add filtering to the out put
for k=1:15
for i=2:length(posXFuseCmp)
    posXFuseCmp(i)=posXFuseCmp(i)*0.8+posXFuseCmp(i-1)*0.2;
end
end
% Compare angle
figure;
plot(time,angleGyro,'b');hold on;
plot(time,XcodeTrueHeading,'g');hold on;
plot(time,angleFuseCmp,'r');
xlabel('Time(s)');
ylabel('Heading angle(degree)');
legend('Gyro Heading','Compass Heading','Fused Heading');
% Compare position
figure;
plot(posYgyro,posXgyro,'b','Linewidth',5);hold on;
plot(posYFuseCmp,posXFuseCmp,'r');
xlabel('PositionY');ylabel('PositionX');
legend('Path based on Gyro','Path based on fused data');
title('Path Comparison');
% Plot onto the map
figure;
plot(LonGyro,LatGyro,'.b','MarkerSize',20);hold on;
plot(LonFuseCmp,LatFuseCmp,'.r','MarkerSize',20);hold on;
hold on;
plot_google_map('MapType','satellite')
title('Fused Data: Gyro Path vs +Compass Path');

%% Section 14: GPS data fusion
figure;
LonFuseGPS = LonFuseCmp;
LatFuseGPS = LatFuseCmp;
size = 100;
for i=size+1:size:length(Lon)
    LonFuseGPS(i)= 0.8*Lon(i)+0.2*LonFuseGPS(i);
    LatFuseGPS(i)= 0.8*Lat(i)+0.2*LatFuseGPS(i);
    plot(Lon(i),Lat(i),'.g','MarkerSize',10);hold on;
end
% Filter
for k=1:2
for i=2:length(Lon)
    LonFuseGPS(i) = 0.3*LonFuseGPS(i)+0.7*Lon(i-1);
    LatFuseGPS(i) = 0.3*LatFuseGPS(i)+0.7*Lat(i-1);
end
end
% Plot on map
plot(LonFuseCmp,LatFuseCmp,'.b','MarkerSize',25);hold on;
plot(LonFuseGPS,LatFuseGPS,'.r','MarkerSize',10);
for i=100+1:80:length(Lon)
    plot(Lon(i),Lat(i),'.g','MarkerSize',5);hold on;
end
hold on;
plot_google_map('MapType','satellite')
title('Fused Data: Compass+Gyro Path vs +GPS Fuse');
