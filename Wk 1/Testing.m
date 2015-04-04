close all;
% accel plot
figure(1);
plot(time03,accel03_X,'r');
hold on;
plot(time03,accel03_Y,'g');
hold on;
plot(time03,accel03_Z,'b');
hold on;
title('Accel 03 Data')
xlabel('Time');
ylabel('Data');
hold off;
legend('x','y','z');
grid on;
%gyro plot
figure(2);
plot(time03,gyro03_X,'r');
hold on;
plot(time03,gyro03_Y,'g');
hold on;
plot(time03,gyro03_Z,'b');
hold on;
title('Gyro 03 Data')
xlabel('Time');
ylabel('Data');
hold off;
legend('x','y','z');
grid on;
