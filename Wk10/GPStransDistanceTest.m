%% Calcualte distance from 2 GPS data: Lat1,Lon1,Lat2,Lon2
clearvars distance;
distance=[0];k=2;
GPSfusionSize = 30;
for i=1:length(Lat)
    % Update stage: Fuse GPS position in:
    R = 6370.8;  % Earth Radius(km)
    if rem(i,GPSfusionSize)==0
        dlon = Long(i) - Long(i-GPSfusionSize+1); 
        dlat = Lat(i) - Lat(i-GPSfusionSize+1); 
        a = (sind(dlat/2))^2 + cosd(Lat(i-GPSfusionSize+1)) * cosd(Lat(i)) * (sind(dlon/2))^2; 
        c = 2 * atan2( sqrt(a), sqrt(1-a)) ;
        d = R * c * 1000; % Distance:Unit:m(where R is the radius of the Earth)
        distance(k,1) = d+distance(k-1);
        k=k+1;
    end
end
figure;plot(distance)

% lat1=-33.8871711446287;
% lon1=151.186982542417;
% lat2=-33.8871920993867;
% lon2=151.187168201572;
% R = 6370.8;
% dlon = lon2 - lon1 
% dlat = lat2 - lat1 
% a = (sind(dlat/2))^2 + cosd(lat1) * cosd(lat2) * (sind(dlon/2))^2 
% c = 2 * atan2( sqrt(a), sqrt(1-a) ) 
% d = R * c 