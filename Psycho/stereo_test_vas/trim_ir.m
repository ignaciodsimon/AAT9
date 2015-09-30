function trim_ir(varargin)

    initCut = 350;
    finalCut = 4000;

    % Load front IRs
    [front_left_IR, samplFreq] = audioread('surround_ir/front_left_1s_01.wav');
    front_right_IR = audioread('surround_ir/front_right_1s_01.wav');

    % Load IRs 30 degrees
    close_30_IR = audioread('surround_ir/side_30_close_2s_01.wav');
    far_30_IR = audioread('surround_ir/side_30_far_2s_01.wav');

    % Load IRs 45 degrees
    close_45_IR = audioread('surround_ir/side_45_close_2s_01.wav');
    far_45_IR = audioread('surround_ir/side_45_far_2s_01.wav');

    % Load IRs 72 degrees
    close_72_IR = audioread('surround_ir/side_72_close_2s_01.wav');
    far_72_IR = audioread('surround_ir/side_72_far_2s_01.wav');

    % Load IRs 110 degrees
    close_110_IR = audioread('surround_ir/side_110_close_2s_01.wav');
    far_110_IR = audioread('surround_ir/side_110_far_2s_01.wav');

    % Load IRs 144 degrees
    close_144_IR = audioread('surround_ir/side_144_close_2s_01.wav');
    far_144_IR = audioread('surround_ir/side_144_far_2s_01.wav');

    % Load IRs 170 degrees
    close_170_IR = audioread('surround_ir/side_170_close_2s_01.wav');
    far_170_IR = audioread('surround_ir/side_170_far_2s_01.wav');

    % Trims IRs to selected range
    front_left_IR = front_left_IR(initCut:finalCut);
    front_right_IR = front_right_IR(initCut:finalCut);
    close_30_IR = close_30_IR(initCut:finalCut);
    far_30_IR = far_30_IR(initCut:finalCut);
    close_45_IR = close_45_IR(initCut:finalCut);
    far_45_IR = far_45_IR(initCut:finalCut);
    close_72_IR = close_72_IR(initCut:finalCut);
    far_72_IR = far_72_IR(initCut:finalCut);
    close_110_IR = close_110_IR(initCut:finalCut);
    far_110_IR = far_110_IR(initCut:finalCut);
    close_144_IR = close_144_IR(initCut:finalCut);
    far_144_IR = far_144_IR(initCut:finalCut);
    close_170_IR = close_170_IR(initCut:finalCut);
    far_170_IR = far_170_IR(initCut:finalCut);

    % Plots trimmed IRs
    plot(front_left_IR, 'b');
    hold on
    plot(front_right_IR, 'r');
    plot(close_30_IR, '');
    plot(far_30_IR, '');
    plot(close_45_IR, '');
    plot(far_45_IR, '');
    plot(close_72_IR, '');
    plot(far_72_IR, '');
    plot(close_110_IR, '');
    plot(far_110_IR, '');
    plot(close_144_IR, '');
    plot(far_144_IR, '');
    plot(close_170_IR, '');
    plot(far_170_IR, '');

    % Saves trimmed IRs to wav files
    audiowrite('trimmed_ir/front_left_IR.wav', front_left_IR, samplFreq);
    audiowrite('trimmed_ir/front_right_IR.wav', front_right_IR, samplFreq);
    audiowrite('trimmed_ir/close_30_IR.wav', close_30_IR, samplFreq);
    audiowrite('trimmed_ir/far_30_IR.wav', far_30_IR, samplFreq);
    audiowrite('trimmed_ir/close_45_IR.wav', close_45_IR, samplFreq);
    audiowrite('trimmed_ir/far_45_IR.wav', far_45_IR, samplFreq);
    audiowrite('trimmed_ir/close_72_IR.wav', close_72_IR, samplFreq);
    audiowrite('trimmed_ir/far_72_IR.wav', far_72_IR, samplFreq);
    audiowrite('trimmed_ir/close_110_IR.wav', close_110_IR, samplFreq);
    audiowrite('trimmed_ir/far_110_IR.wav', far_110_IR, samplFreq);
    audiowrite('trimmed_ir/close_144_IR.wav', close_144_IR, samplFreq);
    audiowrite('trimmed_ir/far_144_IR.wav', far_144_IR, samplFreq);
    audiowrite('trimmed_ir/close_170_IR.wav', close_170_IR, samplFreq);
    audiowrite('trimmed_ir/far_170_IR.wav', far_170_IR, samplFreq);

end
