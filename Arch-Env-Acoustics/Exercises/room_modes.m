function room_modes(varargin)

    % Room characteristics:
    w = 3.55;
    l = 5.73;
    h = 3.03;
    maximumOrder = 100;
    displayAllComputedModes = false;

    % Computes all modes
    clc;
    disp(sprintf('>> Computing the modes up to order %d.', maximumOrder));
    computedModes = zeros(4, maximumOrder^3 - 1);
    i = 1;
    for nx = 0 : maximumOrder
        for ny = 0 : maximumOrder
            for nz = 0 : maximumOrder
                if nx ~= 0 || ny ~= 0 || nz ~= 0
                    modeFreq = computeMode(w, l, h, nx, ny, nz);
                    if displayAllComputedModes
                        disp(sprintf('   Mode (%d-%d-%d): \t%.2f \t[Hz].', nx, ny, nz, modeFreq));
                    end
                    computedModes(:, i) = [nx, ny, nz, modeFreq];
                    i = i + 1;
                end
            end
        end
    end

    % Displays the lowest freq mode
    [minFreq, minFreqIndex] = min(computedModes(4,:));
    disp(sprintf(' > The lowest mode freq is %.2f [Hz], corresponds to (%d-%d-%d).', ...
        minFreq, computedModes(1, minFreqIndex), computedModes(2, minFreqIndex), computedModes(3, minFreqIndex)));
    
    
    % Find the modes withing a certain range of frequencies
    minFreq = 445.44;
    maxFreq = 562.23;
    foundModesCount = 0;
    foundModes = [];
    disp(sprintf('\n>> Finding the modes within the range %.2f - %.2f [Hz]', minFreq, maxFreq));
    for i = 1 : length(computedModes)
        if computedModes(4, i) >=  minFreq && computedModes(4, i) <=  maxFreq
            if displayAllComputedModes
                disp(sprintf('   Mode (%d-%d-%d): \t%.2f \t[Hz].', computedModes(1,i), computedModes(2,i), computedModes(3,i), computedModes(4,i)));
            end
            foundModesCount = foundModesCount + 1;
            foundModes(:, foundModesCount) = computedModes(:,i);
        end
    end
    disp(sprintf(' > Found %d modes withing that frequency range.', foundModesCount));

    % Shows a plot with the mode density over frequency
    hist(computedModes(4,:), 20);
    xlim([0 max(computedModes(4,:))/2]);
    xlabel('Frequency [Hz]');
    ylabel('Amount of modes');
    title('Modes density over frequency');
    grid
end

function modeFreq = computeMode(lx, ly, lz, nx, ny, nz)

    % Sound speed
    c = 343;

    % Computes formula
    modeFreq = (c / 2) * sqrt((nx/lx)^2 + (ny/ly)^2 + (nz/lz)^2);
end