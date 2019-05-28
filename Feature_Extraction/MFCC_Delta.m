function MFCCs_out=MFCC_Delta(MFCCs, delta, delta_delta)

opt = delta*1 + delta_delta*10;
switch opt
	case 00
        MFCCs = MFCCs';
	case 01
        d1 = (DeltaCoeff(MFCCs')).*0.6;	% Computes delta-MFCC
        MFCCs = [MFCCs; d1'];             % Concatenates all together
        MFCCs = MFCCs';
	case 10
        d1 = (DeltaCoeff(MFCCs')).*0.6;	% Computes delta-MFCC
        d2 = (DeltaCoeff(d1)).*0.4;         % Computes delta-delta-MFCC
        MFCCs = [MFCCs; d2'];             % Concatenates all together
        MFCCs = MFCCs';
	case 11
        d1 = (DeltaCoeff(MFCCs')).*0.6;	% Computes delta-MFCC    
        d2 = (DeltaCoeff(d1)).*0.4;         % Computes delta-delta-MFCC
        MFCCs = [MFCCs; d1'; d2'];        % Concatenates all together
        MFCCs = MFCCs';
end

MFCCs_out=MFCCs';

end