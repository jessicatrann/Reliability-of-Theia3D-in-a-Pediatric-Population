clear
% Valid input options
valid_input = ["lankle_x", "lankle_y", "lankle_z", "lhip_x", "lhip_y", "lhip_z", "lknee_x", "lknee_y", "lknee_z", "rankle_x", "rankle_y", "rankle_z", "rhip_x", "rhip_y", "rhip_z", "rknee_x", "rknee_y", "rknee_z"];

% Specify the data directory
pathway1 = pwd;

% Prompt and validate trial input
user_input = lower(input("Please enter the joint and plane for the trials you would like to analyze: ","s"));
while ~ismember(user_input, valid_input)
    disp('The input is invalid. Please try again.')
    user_input = lower(input("Please enter the joint and plane for the trials you would like to analyze: ","s"));
end

% Define the common part of the file names
file_name_prefix = strcat('*', upper(user_input(1)), lower(user_input(2:end)), 'out.csv*');

% Obtain concurrent file
[concurrent_files, concurrent_path] = uigetfile(fullfile(pathway1, file_name_prefix), 'Select the concurrent trials', 'MultiSelect', 'on');
concurrent_files = cellstr(concurrent_files);

% Obtain clothing file
[clothing_files, clothing_path] = uigetfile(fullfile(pathway1, file_name_prefix), 'Select the clothing trials', 'MultiSelect', 'on');
clothing_files = cellstr(clothing_files);

% Load data from concurrent trials file(s)
concurrent_trials = [];
for i = 1:length(concurrent_files)
    concurrent_data = readmatrix(fullfile(concurrent_path, concurrent_files{i}));
    % test(i,:)=concurrent_data; (puts each new file into a new column)
    concurrent_trials = [concurrent_trials; concurrent_data];
end

% Load data from clothing trials file(s)
clothing_trials = [];
for i = 1:length(clothing_files)
    clothing_data = readmatrix(fullfile(clothing_path, clothing_files{i}));  
    clothing_trials = [clothing_trials; clothing_data];
end

% Puts each new data set into a new column
new_concurrent_trials = reshape(concurrent_trials, 101, []);
new_clothing_trials = reshape(clothing_trials, 101, []);

% Calculates the mean of each row for each trial
mean_concurrent = mean(new_concurrent_trials, 2);
mean_clothing = mean(new_clothing_trials, 2);

mean_concurrent_1 = mean_concurrent.*-1;
mean_clothing_1 = mean_clothing.*-1;

% Calculates the difference for each trial between the two trials
difference = mean_concurrent - mean_clothing;
difference_1 = mean_concurrent_1 - mean_clothing_1;

% Calculate RMSE for clothing trials and concurrent trials
length = length(difference);
[s, n] = sumsqr(difference);
a = s/length;
rmse = sqrt(a);

% Displays the RMSD value
disp(['The RMSD value for ', user_input, ' is: ', num2str(rmse)]);

% Plots the mean of the concurrent and clothing trials on the same plot
plot(mean_concurrent_1)
hold on
plot(mean_clothing_1)
legend('MB', 'ML')
title(user_input)
ylabel([user_input,' Flexion'])
xlabel('% Gait Cycle')
str = {'RMSE: ', rmse};
text(7, 7, str)
hold off