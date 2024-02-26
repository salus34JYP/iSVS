function [x,y,r1,r2]=SelectRoi(title)
    %select ROI 
    roi = drawrectangle('Label',title,'StripeColor','y');
    pause
    x=roi.Position(1);
    y=roi.Position(2);
    r1=roi.Position(3);
    r2=roi.Position(4);
end