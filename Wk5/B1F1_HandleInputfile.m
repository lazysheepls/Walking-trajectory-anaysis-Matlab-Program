%% B1F1 function: Handle Input File
%  Details:
%  1. In B1_Rewrite.m : Import file .csv
%  2. Run B1F1 function: -Convert all data in work space to short form
%                        -Convert time
%                        -Clear workspace,left only useful data
%  INPUT: T  %Read table from file
%  OUTPUT: time
%          accelX,accelY,accelZ
%          gyroX,gyroY,gyroZ
%          magnetX,magnetY,magnetZ
%          XcodeTrueHeading,XcodeMagneticHeading,XcodeHeadingAccuracy
%          Lat,Long (stands for GPS data:Latitude,Longitude)
     
%% Function
function [time,accelX,accelY,accelZ,gyroX,gyroY,gyroZ,magnetX,magnetY,magnetZ,XcodeTrueHeading,XcodeMagneticHeading,XcodeHeadingAccuracy,Lat,Long,GPSspeed,GPScourse] = B1F1_HandleInputfile(T)
%  Rearrange time
time = T.accelerometerTimestamp_sinceReboot;
time = time - time(1);
%  Accelerometer data
accelX = T.accelerometerAccelerationX;
accelY = T.accelerometerAccelerationY;
accelZ = T.accelerometerAccelerationZ;
%  Gyroscope data
gyroX = T.gyroRotationX;
gyroY = T.gyroRotationY;
gyroZ = T.gyroRotationZ;
%  Magnetometer data
magnetX = T.locationHeadingX;
magnetY = T.locationHeadingY;
magnetZ = T.locationHeadingZ;
%  Magnetometer Xcode heading data
XcodeTrueHeading = T.locationTrueHeading;
XcodeMagneticHeading = T.locationMagneticHeading;
XcodeHeadingAccuracy = T.locationHeadingAccuracy;
%  GPS data
Lat = T.locationLatitude;
Long = T.locationLongitude;
GPSspeed = T.locationSpeed;
GPScourse = T.locationCourse;
end