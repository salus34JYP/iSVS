%%
%cd ..\2월22일\porh5\

ref_sample_image=Tiff('ss_single_1.tiff');

ref_sample_image_data=read(ref_sample_image);

imagesc(ref_sample_image_data)

roi = drawrectangle('Position',[700,700,300,300],'StripeColor','y');
pause
x=roi.Position(1);
y=roi.Position(2);
r1=roi.Position(3);
r2=roi.Position(4);
colorbar
title("ref&sample","FontSize",10)

test = fft2(ref_sample_image_data(int16(x):int16(x+r1),int16(y):int16(y+r2)));
testshift = fftshift(test);
absshift = log(abs(testshift));
imagesc(absshift)
colorbar
axis image
title("2D FFT result abuout Reference + smaple beam","FontSize",10)

cd ..\code\