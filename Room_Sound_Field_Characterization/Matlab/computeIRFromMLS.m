function computedIR = computeIRFromMLS(usedMLS, recordedSignal)
    %% Obtains the IR by computing the circular cross-correlation between
    %  the used MLS signal and the recorded audio.
    %
    % Joe.

    % Padds the MLS signal to match the length of the recording
    if length(recordedSignal) > length(usedMLS)
        a = [double(usedMLS) zeros(1, length(recordedSignal) - length(usedMLS))];
        b = double(recordedSignal);
    else
        b = [double(recordedSignal) zeros(1, length(usedMLS) - length(recordedSignal))];
        a = double(usedMLS);
    end

    % Normalization
    na = norm(a);
    nb = norm(b);
    a = a / na;
    b = b / nb;

    % Circular cross-correlation
    [~, c] = cxcorr(a, b);

    % This is equivalent to the matlab "cxcorr()" function
    %     c = zeros(size(a));
    %     for k = 1 : length(b)
    %         c(k) = a * b';
    %         % Circular shift
    %         b = [b(end), b(1:end-1)];
    %     end

    computedIR = c;

end
