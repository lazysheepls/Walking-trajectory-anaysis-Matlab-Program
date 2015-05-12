%% B1F9 function: Find Steps from accel Roll angles
%  Details:
%  1. In B1_Rewrite.m : call function and input all variable
%  2. Run B1F9 function: 1.Find steps using accel roll angle
%                        2.Reduce calibration gap noise
%                        3.Record where each step is(stepLocs,stepPks)
%                        4.Record gap time between each steps(stepGaps)
%                        5.Calculate median gap size as avg time per step
%   INPUT: time,RollAccel
%  OUTPUT: stepPks,stepLocs,stepGaps,stepNo,stepAvgGaptime

%% Function
function [stepPks,stepLocs,stepGaps,stepNo,stepAvgGaptime] = B1F9_FindStepsFromAccelRoll(time,RollAccel)
% Step 1: Find local peaks
[stepPks,stepLocs,widths,proms]  = findpeaks(RollAccel,'MinPeakProminence',3);

% Step 2: Compare time interval between steps(sec/step)
% Find all time gap size
clearvars stepGaps;
stepGaps =[0];
for n=1:(length(stepLocs)-1)
    stepGaps(n,1) = time(stepLocs(n+1))-time(stepLocs(n));
    if stepGaps(n,1)>0.6
        stepGaps(n,1)=0.6;  %Step Gap cannot be bigger than 1sec/step
    end
end
% Find average time interval: !!! CANNOT use 'mean', MUST use 'median'
stepAvgGaptime = median(stepGaps);

% Step 3: Noise detection during calibration time: Detect the biggest gap, delete all the data before this gap(noises)
% k=1;
% while stepGaps(k,1)<(stepAvgGaptime*2)
% k=k+1;
% end
% for n=1:k
%     stepLocs(k,:)=[];   % Delete that row if too far away from other steps
%     stepPks(k,:)=[];
%     stepGaps(k,:)=[];
% end
% Record no. of steps
stepNo = length(stepPks);

% Step 4: Plot detected steps and display total number of steps
figure;
plot(time,RollAccel,'b');
hold on
plot(time(stepLocs),RollAccel(stepLocs),'or');
title('Accel Roll angle: Determine steps');
xlabel('time(sec)');
ylabel('Angle(degree)');
displayData=sprintf('Total number of steps is: %d',stepNo); 
disp(displayData);
end