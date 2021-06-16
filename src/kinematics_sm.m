%% initialisation
% @author      Brandon Lu lu0248 2167076
% @year        2021
% @institution Flinders University
% @topic       ENGR7811 Advanced Mechanical Design

% This script calculates the linkage lengths of a crank-slider mechanism as
% per the 13/06/21 log in the ENGR7811 Logbook.
close all;
clear all;
clc;
fprintf('________________________________\n');
fprintf('___________BEGIN PROGRAM________\n');

%% inputs
res = 10; %linspace resolution
range = 20;            %movement range in degrees from negative x axis. A warning will be produced if the range is less than the minimum range.
endLength = 5;         %the distance from the grip target to the end of the part when closed
r_target = 24.225/2;         %the radius of the pole we are gripping. The length of L1 must equal this as a constraint. Assume that the joint A is parallel with initial position of slider D
rx= 30;                %the radial position of the POI:X corresponding to the centreline of the circle
gripWidth = 2;         %the thickness of the segment gripped by the gripper which determines the minimum opening angle

%% calculations
%calibrate angular  movement range
range = [-1*deg2rad(range) 0];
o = -transpose(linspace(range(1),range(2),res));
o = o-pi/2;

%links
r = rx+r_target+endLength;                  % the length of the gripper claw
ox= asin(r_target/rx);                      %the angular position of POI:X

opening = r*sin(o(1)+pi/2)-gripWidth*cos(o(1)+pi/2)+r_target;

l1 = r_target;
l2 = rx - r_target - endLength;              %The length of l2 must not interfere with the pole or gripping POI
l3 = sqrt(l2^2+r_target^2);

%movements
path_r   = [ r.*cos(o-ox)+r_target  r.*sin(o-ox) ];
path_rx  = [ rx.*cos(o)+r_target    rx.*sin(o)   ];
path_l2  = [ l2.*cos(o)+r_target    l2.*sin(o)   ];

phi = -asin((l1+l2.*sin(o+pi/2))./l3);
x = -1*(((l2.*cos(o+pi/2))-l3.*cos(phi)));

%joints
joints = [ 0  r_target        ; %A: pin
    -l2 r_target        ; %B: pin
    0   0               ; %C: pin
    min(x) 0]           ; %D: slider

%% plot
f = figure;
f.Position = [600 600 560 560];
xlim([-100 100]);
ylim([-100 100]);

grid on;
hold on;

%plot joints
scatter(joints(:,1),joints(:,2),'x');

%plot POIs
plot(path_r(:,2), path_r(:,1),'b.','markersize',4);
plot(path_rx(:,2), path_rx(:,1),'g.','markersize',4);


%plot link ends
plot(path_l2(:,2), path_l2(:,1),'r-');

%plot slider range
plot(x,zeros(length(x)),'r-');
%plot target pole section
circle = nsidedpoly(20, 'Center', [-rx 0], 'Radius', r_target);
plot(circle, 'FaceColor', 'r')

%% outputs

if(opening<=r_target)
    fprintf('OPENING IS TOO SMALL, INCREASE OPENING ANGLE\n')
else
    fprintf('For grip segment width of %4.3f [mm] and target radius of %4.3f [mm] at %4.3f [mm] away from the origin:\n',gripWidth,r_target,rx);
    fprintf('    Length of Link 1                 L1 = %5.3f [mm]\n',l1);
    fprintf('    Length of Link 2                 L2 = %5.3f [mm]\n',l2);
    fprintf('    Length of Link 3                 L3 = %5.3f [mm]\n',l3);
    fprintf('    Length of Link 4 Slider Movement L4 = %5.3f [mm]\n',-min(x));
    fprintf('    Opening width                       = %5.3f [mm]\n',2*opening);
    fprintf('    Opening distance from origin        = %5.3f [mm]\n',r);
end
fprintf('___________END PROGRAM__________\n');
fprintf('________________________________\n');




