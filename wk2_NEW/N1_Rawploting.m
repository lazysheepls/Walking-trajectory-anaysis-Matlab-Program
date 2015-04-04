close all;
% Set time
time = time - time(1);
% accel plot
figure(1);
plot(time,acc_X,'r');
hold on;
plot(time,acc_Y,'g');
hold on;
plot(time,acc_Z,'b');
hold on;
title('Accel Data')
xlabel('Time(s)');
ylabel('Data(m/s^2)');
hold off;
legend('x','y','z');
grid on;
%gyro plot
figure(2);
plot(time,gyro_X,'r');
hold on;
plot(time,gyro_Y,'g');
hold on;
plot(time,gyro_Z,'b');
hold on;
title('Gyro Data')
xlabel('Time(s)');
ylabel('Angular speed (rad/s)');
hold off;
legend('x','y','z');
grid on;
