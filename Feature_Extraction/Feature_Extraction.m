function MFCCs=Feature_Extraction(speech, fs, frame_time, frame_lap, alpha, coeffs_num)

speech=LPF(speech);
speech=Pre_Amp(speech, alpha);
frames = FramesWithOverLap(speech, fs, frame_time, frame_lap); 
frames=Windowing(frames);

MFCCs=MFCC(frames, fs, coeffs_num);
MFCCs=MFCC_CMS(MFCCs);
MFCCs=MFCC_Delta(MFCCs, 1, 1);

end