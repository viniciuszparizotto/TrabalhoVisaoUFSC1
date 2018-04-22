clc
clear all


im5 = iread('UFSC5.jpeg','double');
im4 = iread('UFSC4.jpeg','double');
im3 = iread('UFSC3.jpeg','double');
im2 = iread('UFSC2.jpeg','double');
im1 = iread('UFSC1.jpeg','double');


surf1 = isurf(im1);
surf2 = isurf(im2);
surf3 = isurf(im3);
surf4 = isurf(im4);
surf5 = isurf(im5);


m34 = surf3.match(surf4, 'top', 15);
m45 = surf4.match(surf5, 'top', 15);
m32 = surf3.match(surf2, 'top', 15);
m21 = surf2.match(surf1, 'top', 15);


H34 = m34.ransac(@homography, 0.2);
H45 = m45.ransac(@homography, 0.2);
H32 = m32.ransac(@homography, 0.2);
H21 = m21.ransac(@homography, 0.2);


%[im_final4,t4]=homwarp(inv(H34), im4, 'full','extrapval',NaN);
%[im_final5,t5]=homwarp(inv(H34)*inv(H45), im5, 'full','extrapval',NaN);
[im_final2,t2]=homwarp(inv(H32), im2, 'full','extrapval',NaN);
[im_final1,t1]=homwarp(inv(H21)*inv(H32), im1, 'full','extrapval',NaN);
composite = zeros(5000,5000);
[im_final4,t4]=homwarp(inv(H34), im4, 'full','extrapval',NaN);
[im_final5,t5]=homwarp(inv(H34)*inv(H45), im5, 'full','extrapval',NaN);

composite = ipaste(composite, im_final4, t4+1500, 'set');
composite = ipaste(composite, im_final5, t5+1500, 'set');

composite = ipaste(composite, im_final2, 1500+t2, 'set'); 
composite = ipaste(composite, im_final1, 1500+t1, 'set');
composite = ipaste(composite, im3, [1500 1500], 'set');
idisp(composite)