%% This program is for magnet data after calibration and use the calib parameters
close all;

% [e_center, e_radii, e_eigenvecs, e_algebraic] = ellipsoid_fit([magnetX, magnetY, magnetZ]);

% Hard iron error
S = [magnetX - e_center(1), magnetY - e_center(2), magnetZ - e_center(3)]'; % translate and make array

% Soft iron error
scale = inv([e_radii(1) 0 0; 0 e_radii(2) 0; 0 0 e_radii(3)]) * min(e_radii); % scaling matrix
map = e_eigenvecs'; % transformation matrix to map ellipsoid axes to coordinate system axes
invmap = e_eigenvecs; % inverse of above
comp = invmap * scale * map;
S = comp * S; % do compensation
magnetXCab = S(1,:)';
magnetYCab = S(2,:)';
magnetZCab = S(3,:)';

% output info
fprintf( 'Ellipsoid center     :\n                   %.3g %.3g %.3g\n', e_center );
fprintf( 'Ellipsoid radii      :\n                   %.3g %.3g %.3g\n', e_radii );
fprintf( 'Ellipsoid evecs      :\n                   %.6g %.6g %.6g\n                   %.6g %.6g %.6g\n                   %.6g %.6g %.6g\n', e_eigenvecs );
fprintf( 'Ellpisoid comp evecs :\n                   %.6g %.6g %.6g\n                   %.6g %.6g %.6g\n                   %.6g %.6g %.6g\n', comp);

% draw data
figure;
hold on;
plot3( magnetX, magnetY, magnetZ, '.r' ); % original magnetometer data
plot3(S(1,:), S(2,:), S(3,:), 'b.'); % compensated data
view( -70, 40 );
axis vis3d;
axis equal;

% draw ellipsoid fit
figure;
hold on;
plot3( magnetX, magnetY, magnetZ, '.r' );
maxd = max(e_radii);
step = maxd / 50;
[xp, yp, zp] = meshgrid(-maxd:step:maxd + e_center(1), -maxd:step:maxd + e_center(2), -maxd:step:maxd + e_center(3));
Ellipsoid = e_algebraic(1) *xp.*xp +   e_algebraic(2) * yp.*yp + e_algebraic(3)   * zp.*zp + ...
          2*e_algebraic(4) *xp.*yp + 2*e_algebraic(5) * xp.*zp + 2*e_algebraic(6) * yp.*zp + ...
          2*e_algebraic(7) *xp     + 2*e_algebraic(8) * yp     + 2*e_algebraic(9) * zp;
p = patch(isosurface(xp, yp, zp, Ellipsoid, 1));
set(p, 'FaceColor', 'g', 'EdgeColor', 'none');
alpha(0.5);
view( -70, 40 );
axis vis3d;
axis equal;
camlight;
lighting phong;

