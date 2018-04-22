clc
clear all


im5 = iread('building5.jpg', 'double');
im4 = iread('building4.jpg', 'double');
im3 = iread('building3.jpg', 'double');
im2 = iread('building2.jpg', 'double');
im1 = iread('building1.jpg', 'double');


surf1 = isurf(im1);
surf2 = isurf(im2);
surf3 = isurf(im3);
surf4 = isurf(im4);
surf5 = isurf(im5);

%%Busca de Correlação entre as imagens    
m34 = surf3.match(surf4, 'top', 15);
m45 = surf4.match(surf5, 'top', 15);
m32 = surf3.match(surf2, 'top', 15);
m21 = surf2.match(surf1, 'top', 15);

%%Extraimos a homografia planar das correlações entre cada imagem
H34 = m34.ransac(@homography, 0.2);
H45 = m45.ransac(@homography, 0.2);
H32 = m32.ransac(@homography, 0.2);
H21 = m21.ransac(@homography, 0.2);

composite = zeros(5000,5000);
[im_final2,t2]=homwarp(inv(H32), im2, 'full','extrapval',NaN);
[im_final1,t1]=homwarp(inv(H21)*inv(H32), im1, 'full','extrapval',NaN);
[im_final4,t4]=homwarp(inv(H34), im4, 'full','extrapval',NaN);
[im_final5,t5]=homwarp(inv(H34)*inv(H45), im5, 'full','extrapval',NaN);

composite = ipaste(composite, im_final4, t4+1500, 'set');
composite = ipaste(composite, im_final5, t5+1500, 'set');
composite = ipaste(composite, im_final2, 1500+t2, 'set'); 
composite = ipaste(composite, im_final1, 1500+t1, 'set');
composite = ipaste(composite, im3, [1500 1500], 'set');
idisp(composite)