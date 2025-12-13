

function main()
    % Read file line by line
    filename = 'input.txt';
    fid = fopen(filename, 'r');

    if fid == -1
        error('Could not open file: %s', filename);
    end

    matrix = {};
    rawMatrix = {};
    while ~feof(fid)
        line = fgetl(fid);

        % Process each line here
        tokens = strsplit(line, ' ');
        % Remove tokens that are empty or just whitespace
        tokens = tokens(~cellfun('isempty', strtrim(tokens)));

        if size(strfind(line, "+")) > 0
            evaluateMatrix(matrix, tokens);
            evaluateRawMatrix(rawMatrix, tokens);
            
        else
            % Add tokens to matrix
            matrix = [matrix; tokens];
            rawMatrix = [rawMatrix; num2cell(line)]; 
        end
    end
    fclose(fid);
end

function evaluateMatrix(matrix, operations)
    % Iterate over matrix columns and sum all column values
    colSums = zeros(1, size(matrix, 2));
    for col = 1:size(matrix, 2)
        colSum = 0;
        if (operations{col}=='+')
            colSum = 0;
        else
            colSum = 1;
        end
        for row = 1:size(matrix, 1)
            if (operations{col}=='+')
                colSum = colSum + str2double(matrix{row, col});
            else
                colSum = colSum * str2double(matrix{row, col});
            end
        end
        colSums(col) = colSum;
    end
    % Generate sum of colSums
    totalSum = sum(colSums);
    disp('Total sum (Part 1):');
    fprintf('%.0f\n', totalSum);
end

function evaluateRawMatrix(rawMatrix, operations)
    operatorIdx = size(operations, 2);
    numbers = [];
    totalSum = 0;
    for col = 1:size(rawMatrix, 2)
        revCol = size(rawMatrix, 2) - col + 1;
        numberStr = '';
        for row = 1:size(rawMatrix, 1)
            if rawMatrix{row, revCol} == ' '
                continue;
            end
            numberStr = [numberStr, rawMatrix{row, revCol}];
        end
        if size(numberStr) > 0
            numbers = [numbers; str2double(numberStr)];
        end
        if (size(numberStr) == 0) || (revCol == 1)
            % Apply operator to numbers
            if operations{operatorIdx} == "+"
                colSum = sum(numbers);
            else
                colSum = prod(numbers);
            end
            totalSum = totalSum + colSum;
            operatorIdx = operatorIdx - 1;
            numbers = [];       
        end
    end
    disp('Total sum (Part 2):');
    fprintf('%.0f\n', totalSum);
end

