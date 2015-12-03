
function SData = geometry2(SData, displayPlot)

    % Eliminates the fourth loudspeaker microphones (non existent)
    SData = [SData(1) SData(2) SData(3) SData(5) SData(6)];


    SData(1).width = 0.127;

    % Eliminates all data coming from the fourth loudspeaker
    for i = 1:5
        for j = 1:3
                SData(i).microphones(j).recordings = [ ...
                    SData(i).microphones(j).recordings(1), ...
                    SData(i).microphones(j).recordings(2), ...
                    SData(i).microphones(j).recordings(3), ...
                    SData(i).microphones(j).recordings(5), ...
                    SData(i).microphones(j).recordings(6) ];
        end
    end

    % Finds the position and orientation
    SData = multidimensional_positions(SData, displayPlot);
    SData = orientations(SData);

%     draw(SData(1).position, SData(2).position, SData(3).position, SData(4).position, SData(5).position,...
%     SData(1).orientation, SData(2).orientation, SData(3).orientation, SData(4).orientation, SData(5).orientation);

end
