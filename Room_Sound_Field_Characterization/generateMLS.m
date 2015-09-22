function outputSignal = generateMLS(sequenceOrder)
    %% Generates a MLS signal of the given order.
    %
    % Joe.

    mls_registers = ones(1, ceil(sequenceOrder));
    mls_signal = zeros(1, length(mls_registers));

    for n = 1 : 2^length(mls_registers)-1

        % Last takes the value of first plus second
        sumValue = mls_registers(1) + mls_registers(2);

        % Makes operation binary
        if sumValue > 1
            sumValue = 0;
        end

        % Rotates all registers
        for m = 1 : length(mls_registers) -1
            mls_registers(m) = mls_registers(m+1);
        end

        mls_registers(length(mls_registers)) = sumValue;

        % Saves the current output
        mls_signal(n) = mls_registers(1);

    end

    outputSignal = mls_signal - mean(mls_signal);

end
