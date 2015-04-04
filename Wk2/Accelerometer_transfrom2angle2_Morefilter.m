% 10 Mar
% Transfer filtered accel data to angle related to XY, XZ, YZ plane
% Input: accel_AxyFilteredD
close all;

% % Method 1: FFT analysis
% F = fft(accel_AxyFilteredD);
% figure;
% plot(abs(F(1:data_size/2)));

% % Mehod 2: Butterworth filter
% f_cutoff = 0.03;
% [b1,a1] = butter(2,f_cutoff,'low');
% ButterResult = filter(b1,a1,acc_X);
% 
% figure;
% subplot(1,2,1);
% plot(acc_X);
% subplot(1,2,2);
% plot(ButterResult);
% FFTsignal = fft(signal, data_size);
% FilterFreqResponse = freqz(b,a,data_size,'whole');
% FFTfilteredSignal = FFTsignal .* FilterFreqResponse;
% filteredSignal = ifft(FFTfilteredSignal, data_size);

% Method 3: Find peaks
k=-mean(accel_AxyFilteredD);
[pks_max,locs_max]= findpeaks(accel_AxyFilteredD-mean(accel_AxyFilteredD));
temp_inverted = -(accel_AxyFilteredD-mean(accel_AxyFilteredD));
[pks_min,locs_min]= findpeaks(temp_inverted);
pks_min = -pks_min;
figure(1);
plot(time,accel_AxyFilteredD-mean(accel_AxyFilteredD),time(locs_max),pks_max,'or');
hold on;
plot(time(locs_min),pks_min,'rv');
grid on;

%%%% Resize both pks into same size
length_maxPks = length(pks_max);
length_minPks = length(pks_min);
min_length = min(length_maxPks,length_minPks);
RZlocs_max = locs_max(1:min_length);
RZlocs_min = locs_min(1:min_length);
RZpks_max = pks_max(1:min_length);
RZpks_min = pks_min(1:min_length);

%%%%% Filter exterme data
NEWpks(1)=pks_min(1);
NEWlocs(1)=locs_min(1);
factor=0.5;
k=2;
for n=2:length(RZlocs_min)-1
    if abs(RZpks_max(n)-RZpks_min(n))<50
        NEWpks(k,1)=(RZpks_min(n)+RZpks_max(n))/2;
        NEWlocs(k,1)=locs_min(n);
        k = k+1;
    end
end
NEWpks(k,1)=RZpks_min(n+1);
NEWlocs(k,1)=RZlocs_min(n+1);
% NEWlocs = NEWlocs.* 0.05;
k=2;
NNEWpks(1) = NEWpks(1);
NNEWlocs(1)= NEWlocs(1);
for n=2:length(NEWlocs)
    if abs(NEWpks(n)-NEWpks(n-1))<30
        NNEWpks(k,1)=NEWpks(n);
        NNEWlocs(k,1)=NEWlocs(n);
        k = k+1;
    end
end
NNEWlocs = NNEWlocs.* 0.05;
% pks_avg = (pks_max - pks_min)/2 + pks_min;
% temp = smooth(accel_AxyFilteredD,10);
% temp = sgolayfilt(accel_AxyFilteredD,7,21);
% plot(time,temp);
% plot(time,pks_avg);


hold on;
plot(NNEWlocs,NNEWpks,'bd');
hold on;
createFit(NNEWlocs, NNEWpks);

