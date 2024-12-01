% HW 4
% Q1 and Q2


function bw = BlackWhite2D(img_init, mask_init)
    % Constructor function to initialize the structure
    if nargin < 2
        mask_init = [0 1 0; 1 1 1; 0 1 0]; % Default mask
    end
    bw.image0 = logical(img_init); % Ensure the image is logical
    bw.mask = logical(mask_init); % Ensure the mask is logical
    bw.grow = @(varargin) grow_image(bw.image0, bw.mask, varargin{:});
end

function output = grow_image(image0, mask, varargin)
    % Grow function for binary image
    if isempty(varargin)
        iternum = 1; % Default iteration number
        newmask = mask;
    elseif length(varargin) == 1
        iternum = varargin{1};
        newmask = mask;
    elseif length(varargin) == 2
        iternum = varargin{1};
        newmask = logical(varargin{2}); % Ensure the new mask is logical
    else
        error('Too many input arguments.');
    end
    
    % Get mask dimensions
    [mask_rows, mask_cols] = size(newmask);
    R = (mask_rows - 1) / 2; % Calculate the half-width
    
    % Validate that the mask is square
    if mask_rows ~= mask_cols || mod(mask_rows, 2) == 0
        error('Mask must be a square matrix with odd dimensions.');
    end
    
    % Pad the image
    padded_image = padarray(image0, [R R], 0);
    output = image0; % Initialize output with the original image
    
    % Iterative growing
    for iter = 1:iternum
        new_output = output; % Temporary storage for the updated image
        for i = 1:size(output, 1)
            for j = 1:size(output, 2)
                % Extract sub-image under the mask
                sub_img = padded_image(i:i+2*R, j:j+2*R);
                % Apply the mask and update the center pixel
                new_output(i, j) = any(sub_img(newmask));
            end
        end
        % Update the padded image for the next iteration
        padded_image(R+1:end-R, R+1:end-R) = new_output;
        output = new_output;
    end
end
