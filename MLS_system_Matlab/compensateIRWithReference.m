function correctedID = compensateIRWithReference(measuredIR, referenceIR)
    %% Corrects an impulse response with the known self IR of the system.
    %  This is used to compensate for the system latency and possible
    %  defects on the frequency response.
    %
    %  Joe.

    if length(measuredIR) ~= length(referenceIR)
        if length(measuredIR) > length(referenceIR)
            % Pad the reference with zeros
            referenceIR = [referenceIR , zeros(1, length(measuredIR) - length(referenceIR))];
        else
            % Pad the measured IR
            measuredIR = [measuredIR , zeros(1, length(referenceIR) - length(measuredIR))];
        end
    end
    
    fft_signal = fft(measuredIR);
    fft_reference = fft(referenceIR);

    result_mod = abs(fft_signal) ./ abs(fft_reference);
    result_pha = phase(fft_signal) - phase(fft_reference);

    realPart = result_mod .* cos(result_pha);
    imagPart = result_mod .* sin(result_pha);

    % Returns IR of computed spectrum
    correctedID = real(ifft(realPart + 1i*imagPart));    

end