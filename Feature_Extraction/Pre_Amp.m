function speech_out=Pre_Amp(speech, alpha)

for i=2:length(speech)
    speech_out(i)=speech(i)-alpha*speech(i-1);
end
speech_out(1)=speech_out(2);





end
