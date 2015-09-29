
function stereo_test_vas(inputarg)

    [position, slider] = showLocalizationPlot();
    disp(sprintf('Position: %.2f, %.2f. Slider: %.2f', position(1), position(2), slider));

    
    
    
    
end

function outputSound = convolveSound()


end

function [position, slider] = showLocalizationPlot()

    %windowTitle = 'My title';
    %plotTitle = 'Plot title';
    backColor = [.82 .81 .8];
    windowTitle = 'Stereo perception test - AAT9 2015.';
    position = [-1, -1];
    slider = 50;
    positionAlreadySelected = false;

    % Loads the background image from file
    img = imread('plot_background.png');

    % Creates the figure with the desired size, centered on screen
    hFig = figure('Color', backColor);
    set(hFig,'Name', windowTitle, 'NumberTitle','off')
    hold on;
    set(hFig, 'Position', [0 0 520 650])
    movegui(hFig, 'north')

    % Callback for the click
    set(hFig,'windowbuttondownfcn',@fhbdfcn)

    % Removes the toolbar and the menu bar
    set(hFig, 'MenuBar', 'none');
    set(hFig, 'ToolBar', 'none');
    set(gca,'xtick',[],'ytick',[])

    % Sets the canvas position
    set(gca,'Position',[0.05 0.2 0.9 0.7])

    % Displays the background image
    image([-300 300], [300 -300], img);
    axis([-300 300 -300 300])

    % Sets the title to the plot
    title('Click where the source was perceived', ...
          'FontSize', 16, 'FontWeight', 'normal');

    % -- Internal callbacks --

    function [] = fhbdfcn(h, ~)

        % Gets the position coordinates
        positionCoordinates = get(gca, 'currentpoint');
        positionCoordinates = [positionCoordinates(1, 1) 
                               positionCoordinates(1, 2)];

        if ~positionAlreadySelected

            % Checks that the click is within the boundaries
            if positionCoordinates(1) > 300 || positionCoordinates(1) < -300
                return
            end
            if positionCoordinates(2) > 300 || positionCoordinates(2) < -300
                return
            end

            % Displays a mark on the selected point
            plot([positionCoordinates(1)], [positionCoordinates(2)], ...
                 'x', 'MarkerSize', 30, 'LineWidth', 3);

            % Saves the selected position
            position = positionCoordinates;

            % Adds slider for the perceived realism
%             m = ones(100,1)*(1:100);
            hsl = uicontrol('Style','slider','Min',1,'Max', 100,...
                            'SliderStep',[1 1]./100,'Value', 52,...
                            'Position',[130 50 250 20]);

            % Wires callback for the slider
            set(hsl, 'Callback', @callbackSlider)

            % Adds boton to continue
            uicontrol('Style', 'pushbutton', 'String', 'Continue',...
                'Position', [220 10 70 30],...
                'Callback', 'close');

            % Adds label for 'Perceived realism'
            uicontrol('Style','text',...
                'Position',[160 80 200 20],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String','Perceived realism valoration:');

            % Adds label for 'very fake'
            uicontrol('Style','text',...
                'Position',[80 30 40 50],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String', sprintf('Very\nfake'));

            % Adds label for 'very realistic'
            uicontrol('Style','text',...
                'Position',[390 30 70 50],...
                'BackgroundColor', backColor, ...
                'FontSize', 14, ...
                'String', sprintf('Very\nrealistic'));

            % Removes the title
            title('');

            % Flag of 'position already selected'
            positionAlreadySelected = true;
        end
    end
    
    function callbackSlider(hObject, evt)
        slider = get(hObject, 'Value');
    end

    % Waits until the window is closed
    waitfor(hFig);

end
