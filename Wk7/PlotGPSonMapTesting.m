%% Plot GPS data testing: Sun April, 26 wk7
%  Based on function: plot_google_map.m 
%  Based on google static map API(Broswer)
%  How to use:
%  - Do normal plotting of Long and Lat data in the front.
%  - When finishing config all Long and Lat data: Call plot_google_map('the settings u want')

%%
close all;
lat = Lat
lon = Long;
plot(lon,lat,'.r','MarkerSize',20)
hold on;
% lat = [60 60 73 54 32 69]; 
% lon = [2.4131 -0.1300 12.4951 -3.6788 13.415 23.715]; 
% plot(lon,lat,'.c','MarkerSize',20)
%% Set API key: only need to do it once
%  API key: AIzaSyBCA_bJ4J52eNG1pOcih3JxMXnxkIZsrI4
%  plot_google_map('APIKey','AIzaSyBCA_bJ4J52eNG1pOcih3JxMXnxkIZsrI4')
%% Plot map
plot_google_map('MapType','satellite');