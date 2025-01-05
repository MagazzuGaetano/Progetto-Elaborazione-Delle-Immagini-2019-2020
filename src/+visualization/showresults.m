function showresults(im, errors, errorTypes)
%SHOWRESULTS plot mistakes of a not compliant box image

[r,~,~] = size(im);
imshow(im);
hold on;

legendHandles = [];

if ~isempty(errors)
    rs = ones(size(errors, 1), 1) * 150;

    if ~errorTypes
        errors = [errors.x; errors.y]';
        
        if ~isempty(errors)
            viscircles(errors, rs * 1, 'EdgeColor', 'red', 'LineWidth', 3);
        end

        text(100, (r - 100), "NON CONFORME",'FontSize',14,'Color','red');
    else

        misplacedErrors = errors(strcmp({errors.error_type}, 'misplaced'));
        rejectErrors = errors(strcmp({errors.error_type}, 'reject'));
        stampErrors = errors(strcmp({errors.error_type}, 'stamp_not_found'));

        misplacedCoords = [[misplacedErrors.x]' [misplacedErrors.y]'];
        rejectCoords = [[rejectErrors.x]' [rejectErrors.y]'];
        stampCoords = [[stampErrors.x]' [stampErrors.y]'];

        % Plot the circles only for the errors that exist
        if ~isempty(misplacedErrors)
            h1 = viscircles(misplacedCoords, rs * 0.9, 'EdgeColor', 'cyan', 'LineWidth', 3);
            legendHandles = [legendHandles, h1];
        end
        if ~isempty(rejectErrors)
            h2 = viscircles(rejectCoords, rs * 1, 'EdgeColor', 'magenta', 'LineWidth', 3);
            legendHandles = [legendHandles, h2];
        end
        if ~isempty(stampErrors)
            h3 = viscircles(stampCoords, rs * 1, 'EdgeColor', 'yellow', 'LineWidth', 3);
            legendHandles = [legendHandles, h3];
        end

        % Create the legend dynamically based on which errors exist
        legendText = {};
        if ~isempty(misplacedErrors)
            legendText{end+1} = 'MISPLACED: ' + string(size(misplacedErrors, 2));
        end
        if ~isempty(rejectErrors)
            legendText{end+1} = 'REJECT: ' + string(size(rejectErrors, 2));
        end
        if ~isempty(stampErrors)
            legendText{end+1} = 'MISSING STAMP: ' + string(size(stampErrors, 2));
        end

        legend(legendHandles, legendText, 'Location', 'northeast', 'FontSize', 12);

    end

else
    % If no errors, display a message and set legend
    text(100, (r - 100), "CONFORME",'FontSize',14,'Color','green');
end

hold off;

end
