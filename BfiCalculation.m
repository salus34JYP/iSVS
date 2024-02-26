function F=BfiCalculation()

    clc, clear, close

%% read test reference & sample image 

    % read reference image
    ref_image=Tiff('ref.tiff','r');
    ref_image_data=read(ref_image);
    imagesc(ref_image_data)    
    colorbar

    [x,y,xr,yr]=SelectRoi('ROI of refernce');
    close
    % mean reference intensity 
    mean_Ir=mean2(ref_image_data(int16(x):int16(x+xr),int16(y):int16(y+yr)));
    
%% set ROI of image and FFT image
   
    %find location of images
    current_folder=pwd;
    cd ..\
    MyData=uigetdir();
    cd(MyData)

    %find number of images
    temp=dir('*.tiff');
    len=size(temp,1);
    F=zeros(1,len);
    
    %select ROI 
    ref_sam_image=Tiff('ss_single_1.tiff','r');
    ref_sam_image_data=read(ref_sam_image);
    imagesc(ref_sam_image_data)
    colorbar
    cd(current_folder)
    [x1,y1,xr1,yr1]=SelectRoi('ROI of refence and sample');    
    close
    
    imagefft = fft2(ref_sam_image_data(int16(x1):int16(x1+xr1),int16(y1):int16(y1+yr1)));
    imagefftshift = fftshift(imagefft);
    imagesc(log(abs(imagefftshift)))
    colorbar
    [x2,y2,xr2,yr2]=SelectRoi('ROI of interference');
    [x3,y3,xr3,yr3]=SelectRoi('ROI of sample');
    close

%% fft shift and image plot
    
    cd(MyData)

    for i = 1:len

        num = num2str(i);
        str = strcat("ss_single_",num,".tiff");
        tiff = Tiff(str);
        r = read(tiff);
        imagefft = fft2(r(int16(x1):int16(x1+xr1),int16(y1):int16(y1+yr1)));
        imagefftshift = fftshift(imagefft);
        
        absshift = abs(imagefftshift);
        roifft = absshift(int16(x2):int16(x2+xr2),int16(y2):int16(y2+yr2));
        Is = absshift(int16(x3):int16(x3+xr3),int16(y3):int16(y3+yr3));
        mean_Is=mean2(Is);
    
        imagefftshiftabs = roifft;
        FFTimage_kj(:,:,i) = imagefftshiftabs;

        
F(i) = mean(imagefftshiftabs,"all")/(mean_Is*mean_Ir);
    end

    cd(current_folder) 
%%    
    %plot F & lowpass filtered F
    fs=0.1;
    time=fs:fs:len*fs;
    plot(time,F)
    xlabel('time')
    ylabel('F')
    title("F value","FontSize",10)

end



