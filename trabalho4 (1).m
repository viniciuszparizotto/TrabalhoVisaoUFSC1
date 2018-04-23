%% Leitura das imagens
im5 = iread('building5.jpg', 'double');
im4 = iread('building4.jpg', 'double');
im3 = iread('building3.jpg', 'double');
im2 = iread('building2.jpg', 'double');
im1 = iread('building1.jpg', 'double');

%% Detecção dos pontos das imagens
surf1 = isurf(im1);
surf2 = isurf(im2);
surf3 = isurf(im3);
surf4 = isurf(im4);
surf5 = isurf(im5);

%% Match entre os pontos das figuras
m34 = surf3.match(surf4, 'top', 15);
m45 = surf4.match(surf5, 'top', 15);
m32 = surf3.match(surf2, 'top', 15);
m21 = surf2.match(surf1, 'top', 15);

%% Homografia entre as imagens
H34 = m34.ransac(@homography, 0.2);
H45 = m45.ransac(@homography, 0.2);
H32 = m32.ransac(@homography, 0.2);
H21 = m21.ransac(@homography, 0.2);

%% Aplicação da homografia
[im_final4,t4]=homwarp(inv(H34), im4, 'full');
[im_final5,t5]=homwarp(inv(H34)*inv(H45), im5, 'full');
[im_final2,t2]=homwarp(inv(H32), im2, 'full');
[im_final1,t1]=homwarp(inv(H21)*inv(H32), im1, 'full');

%% União das imagens
s1=size(im_final1);
s2=size(im_final2);
s3=size(im3);
s4=size(im_final4);
s5=size(im_final5);


composite = zeros(s2(2) +400 , s3(1)+s1(1)+s5(1)+300);

composite = ipaste(composite, im_final4, t4+[-t1(1)+10 -t5(2)+50], 'set'); 
composite = ipaste(composite, im_final5, t5+[-t1(1)+10 -t5(2)+50], 'set');
composite = ipaste(composite, im_final2, t2+[-t1(1)+10 -t5(2)+50], 'set'); 
composite = ipaste(composite, im_final1, t1+[-t1(1)+10 -t5(2)+50], 'set');
composite = ipaste(composite, im3, [-t1(1)+10 -t5(2)+50], 'set');

idisp(composite)