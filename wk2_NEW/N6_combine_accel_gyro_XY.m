% wk2
% Use Complementary Filter to combine Accel and gyro data
% factor difinition
close all;
alfa_pitch = 0.02;
AngleX_pitch_FT = alfa_pitch.* AngleGY_X + (1-alfa_pitch) .* Ay_pitchX;
alfa_roll = 0.02;
AngleY_roll_FT = alfa_roll.* AngleGY_Y + (1-alfa_roll) .* Ax_rollY;

figure;
plot(time,AngleX_pitch_FT,'r');
hold on;
plot(time,AngleY_roll_FT,'b');
legend('x','y');
title ('Pitch Roll and Yaw angle combined');
xlabel('Time(s)');
ylabel('Angle(degree)');
grid on;


