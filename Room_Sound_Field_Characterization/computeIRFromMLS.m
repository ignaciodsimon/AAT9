function computedIR = computeIRFromMLS(usedMLS, recordedSignal)
    %% Obtains the IR by computing the circular cross-correlation between
    %  the used MLS signal and the recorded audio.
    %
    % Joe.

    % Padds the MLS signal to match the length of the recording
    b = [double(usedMLS) zeros(1, length(recordedSignal) - length(usedMLS))];
    a = double(recordedSignal)';
    
    % Normalization
    na = norm(a);
    nb = norm(b);
    a = a / na;
    b = b / nb;

    % The main loop is equivalent to the MatLab function (and takes the
    % same amount of time)
    % [x, c] = cxcorr(a, b);

    c = zeros(size(a));
    for k = 1 : length(b)
        c(k) = a * b';
        % Circular shift
        b = [b(end), b(1:end-1)];
    end
    computedIR = c;

end
