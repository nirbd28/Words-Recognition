function MFCCs_out=MFCC_CMS(MFCCs)

[~,FramesNum]=size(MFCCs);
meanceps = mean(MFCCs,2);
MFCCs_out = MFCCs - repmat(meanceps,1,FramesNum);

end