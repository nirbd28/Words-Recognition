function MFCCs = MFCC(frames, fs, coeffs_num)

% Find the Mel frequency cepstral coefficients corresponding to an 
% input speech signal. Also calculates the first and second derivatives.
%
% INPUTS: 
%
% Input: Matrix of speech frames. Each row represents a frame of speech.
% Fs: Sampling Frequency in Hz.
% CoeffNum: The number of cepstral coefficients, usually 13.
% With_Delta: Calculates also the first derivative (when equal to 1).
% With_DeltaDelta: Calculates also the second derivative (when equal to 1).
%
% OUTPUTS:
%
% coeffs: Matrix of the MFCC coefficents and their derivatives (if wanted).
%         Each feature vector in a row.

[~,FramesNum] = size(frames);	% Get frame size and number of frames

% Filter bank parameters
lowestFrequency = 133.3333;
linearFilters = 13;
linearSpacing = 66.66666666;
logFilters = 27;
logSpacing = 1.0711703;
fftSize = 256;	% Actualy fft of 512

totalFilters = linearFilters + logFilters;

% Now figure the band edges. Interesting frequencies are spaced
% by linearSpacing for a while, then go logarithmic. First figure
% all the interesting frequencies. Lower, center, and upper band
% edges are all consequtive interesting frequencies.

freqs = lowestFrequency + (0:linearFilters-1)*linearSpacing;
freqs(linearFilters+1:totalFilters+2) = ...
freqs(linearFilters) * logSpacing.^(1:logFilters+2);

lower = freqs(1:totalFilters);
center = freqs(2:totalFilters+1);
upper = freqs(3:totalFilters+2);

% Now, we want to combine FFT bins so that each filter has unit
% weight, assuming a triangular weighting function. First figure
% out the height of the triangle, then we can figure out each
% frequencies contribution.

MFCCFilterWeights = zeros(totalFilters,fftSize);
triangleHeight = 2./(upper-lower);
fftFreqs = (0:fftSize-1)/fftSize*fs;

for chan=1:totalFilters
	MFCCFilterWeights(chan,:) = ...
    (fftFreqs > lower(chan) & fftFreqs <= center(chan)).* ...
    triangleHeight(chan).*(fftFreqs-lower(chan))/(center(chan)-lower(chan)) + ...
    (fftFreqs > center(chan) & fftFreqs < upper(chan)).* ...
    triangleHeight(chan).*(upper(chan)-fftFreqs)/(upper(chan)-center(chan));
end

% Figure out Discrete Cosine Transform. We want a matrix
% dct(i,j) which is totalFilters x CoeffNum in size.
% The i,j component is given by:
% cos(i*(j+0.5)/totalFilters*pi),
% where we have assumed that i and j start at 0.

MFCCDCTMatrix = 1/sqrt(totalFilters/2)*cos((0:(coeffs_num-1))' * ...
(2*(0:(totalFilters-1))+1) * pi/2/totalFilters);
MFCCDCTMatrix(1,:) = MFCCDCTMatrix(1,:) * sqrt(2)/2;

% Ok, now let's do the processing.  For each chunk of data:
%	* Find the magnitude of the FFT.
%	* Convert the FFT data into filter bank outputs.
%	* Find the log base 10.
%	* Find the cosine transform to reduce dimensionality.
%	* Perform cepstral mean subtraction.

fftMag = abs(fft(frames,2*fftSize));
fftMag = fftMag(1:fftSize,:);
earMag = log10(MFCCFilterWeights * fftMag);
MFCCs = MFCCDCTMatrix * earMag;
 
end