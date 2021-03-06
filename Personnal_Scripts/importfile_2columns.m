function DataTestsWelcome = importfile_2columns(filename, startRow, endRow)
%IMPORTFILE1 Import numeric data from a text file as a matrix.
%   TESTXCOORDINATE0YCOORDINATE50NUMSTEP50FREQ1 = IMPORTFILE1(FILENAME)
%   Reads data from text file FILENAME for the default selection.
%
%   TESTXCOORDINATE0YCOORDINATE50NUMSTEP50FREQ1 = IMPORTFILE1(FILENAME,
%   STARTROW, ENDROW) Reads data from rows STARTROW through ENDROW of text
%   file FILENAME.
%
% Example:
%   testXCoordinate0YCoordinate50NumStep50Freq1 =
%   importfile1('test_X_Coordinate_0_Y_Coordinate_-50Num_Step_50Freq_1.txt',
%   5, 1004);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2015/11/04 10:17:34

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 5;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: text (%s)
%	column4: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%s%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
DataTestsWelcome = table(dataArray{1:end-1}, 'VariableNames', {'time0','Volt0','time1','Volt1'});
