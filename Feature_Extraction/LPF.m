function speech_out=LPF(speech)
% IIR LPF with Fc = 4kHz adapted to Fs = 8kHz

speech_out(1)=speech(1);
for i=2:length(speech)
	speech_out(i)=speech(i)+speech(i-1)-0.96079842651911895*speech_out(i-1);
end

end