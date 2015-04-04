close all;
% accel plot
figure(1);
plot(time04,acc_X,'r');
hold on;
plot(time04,acc_Y,'g');
hold on;
plot(time04,acc_Z,'b');
hold on;
title('Accel 04 Data')
xlabel('Time(s)');
ylabel('Data(m/s^2)');
hold off;
legend('x','y','z');
grid on;
%gyro plot
figure(2);
plot(time04,gyro_X,'r');
hold on;
plot(time04,gyro_Y,'g');
hold on;
plot(time04,gyro_Z,'b');
hold on;
title('Gyro 04 Data')
xlabel('Time(s)');
ylabel('Data(m/s^2)');
hold off;
legend('x','y','z');
grid on;
