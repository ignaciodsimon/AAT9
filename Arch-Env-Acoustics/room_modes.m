function room_modes(varargin)

    % Room characteristics:
    w = 3.55;
    l = 5.73;
    h = 3.03;
    maximumOrder = 1;

    clc;
    disp(sprintf(' >> Computing the modes up to order %d.\n', maximumOrder));
    computedModes = zeros(4, maximumOrder^3 - 1);

    % Computes all modes
    i = 1;
    for nx = 0 : maximumOrder
        for ny = 0 : maximumOrder
            for nz = 0 : maximumOrder
                if nx ~= 0 || ny ~= 0 || nz ~= 0
                    modeFreq = computeMode(w, l, h, nx, ny, nz);
                    disp(sprintf('Mode (%d-%d-%d): \t%.2f \t[Hz].', nx, ny, nz, modeFreq));
                    computedModes(:, i) = [nx, ny, nz, modeFreq];
                    i = i + 1;
                end
            end
        end
    end

    % Displays the lowest freq mode
    [minFreq, minFreqIndex] = min(computedModes(4,:));
    disp(sprintf('\n> The lowest mode freq is %.2f [Hz], corresponds to (%d-%d-%d).', ...
        minFreq, computedModes(1, minFreqIndex), computedModes(2, minFreqIndex), computedModes(3, minFreqIndex)));
end

function modeFreq = computeMode(lx, ly, lz, nx, ny, nz)

    % Sound speed
    c = 343;

    % Computes formula
    modeFreq = (c / 2) * sqrt((nx/lx)^2 + (ny/ly)^2 + (nz/lz)^2);
end