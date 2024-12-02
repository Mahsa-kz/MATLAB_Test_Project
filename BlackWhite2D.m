% HW 4
% Q1 and Q2

classdef BlackWhite2D
    properties (Access = private)
        image0  % Private property to store the original binary image
    end
    properties
        mask  % Public property to store the binary mask
    end
    methods
        % Constructor
        function obj = BlackWhite2D(img_init, mask_init)
            if nargin < 2
                mask_init = [0 1 0; 1 1 1; 0 1 0];  % Default mask
            end
            obj.image0 = logical(img_init);  % Ensure the image is logical
            obj.mask = logical(mask_init);  % Ensure the mask is logical
        end

        % Grow method
        function output = grow(obj, iternum, newmask)
            if nargin < 2
                iternum = 1;  % Default iteration number
            end
            if nargin < 3
                newmask = obj.mask;  % Use the object's mask if not provided
            else
                newmask = logical(newmask);  % Ensure the new mask is logical
            end
            
            % Get mask dimensions
            [mask_rows, mask_cols] = size(newmask);
            R = (mask_rows - 1) / 2;  % Calculate the half-width
            
            % Manual zero-padding
            [rows, cols] = size(obj.image0);
            padded_image = zeros(rows + 2*R, cols + 2*R);  % Create zero-padded matrix
            padded_image(R+1:end-R, R+1:end-R) = obj.image0;  % Place original image in the center
            
            output = obj.image0;  % Initialize output with the original image
            
            % Iterative growing
            for iter = 1:iternum
                new_output = output;  % Temporary storage for updated image
                for i = 1:rows
                    for j = 1:cols
                        % Extract sub-image under the mask
                        sub_img = padded_image(i:i+2*R, j:j+2*R);
                        % Update the center pixel using the grow rule
                        new_output(i, j) = any(sub_img(newmask));
                    end
                end
                % Update padded image for the next iteration
                padded_image(R+1:end-R, R+1:end-R) = new_output;
                output = new_output;
            end
        end

        % Shrink method
        function output = shrink(obj, iternum, newmask)
            if nargin < 2
                iternum = 1;  % Default iteration number
            end
            if nargin < 3
                newmask = obj.mask;  % Use the object's mask if not provided
            else
                newmask = logical(newmask);  % Ensure the new mask is logical
            end
            
            % Get mask dimensions
            [mask_rows, mask_cols] = size(newmask);
            R = (mask_rows - 1) / 2;  % Calculate the half-width
            
            % Manual one-padding
            [rows, cols] = size(obj.image0);
            padded_image = ones(rows + 2*R, cols + 2*R);  % Create one-padded matrix
            padded_image(R+1:end-R, R+1:end-R) = obj.image0;  % Place original image in the center
            
            output = obj.image0;  % Initialize output with the original image
            
            % Iterative shrinking
            for iter = 1:iternum
                new_output = output;  % Temporary storage for updated image
                for i = 1:rows
                    for j = 1:cols
                        % Extract sub-image under the mask
                        sub_img = padded_image(i:i+2*R, j:j+2*R);
                        % Update the center pixel using the shrink rule
                        new_output(i, j) = all(sub_img(newmask));
                    end
                end
                % Update padded image for the next iteration
                padded_image(R+1:end-R, R+1:end-R) = new_output;
                output = new_output;
            end
        end
    end
end
