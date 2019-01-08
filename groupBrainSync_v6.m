function [X2, Os, Costdif, TotalError] = groupBrainSync_v6(S)
    
    [numT, numV, SubNum] = size(S);

    % init random matrix for Os
    Os = zeros(numT, numT, SubNum);
    for i = 1:SubNum  %initializeing O
        R = 2 * rand(numT, numT) - 1; %define a random matrix with unity distributian from -1 to 1
        R = (R * R')^(-1/2) * R;  %orthogonal rows of matrix
        Os(:, :, i) = R';
    end
    
    Error = 1;
    PreError = 1;
    relcost = 1;
    
    alpha = 1e-6;
    var = 0;
    Costdif = zeros(10000, 1);
    
    disp('init done');
    
   %% Initialize PreError from gloal average
   X = zeros(numT, numV); 
   for j = 1:SubNum  %calculate X
        X = Os(:, :, j) * S(:, :, j) + X;
   end
   X = X./SubNum;
   InError=0;     
   for j = 1:SubNum
        etemp = Os(:, :, j) * S(:, :, j) - X;
        InError = InError + trace(etemp*etemp'); %calculating error
   end
    
    %% Find best Orthogognal map, by minimizing error (distance) from average 
    while (relcost > alpha)
        var = var + 1;
        
        for i = 1:SubNum
            disp('subject iteration');
            disp(i);
            X = zeros(numT, numV);
            for j = 1:SubNum  %calculate X average excluded subject i
                if j ~= i
                    X = Os(:, :, j) * S(:, :, j) + X;
                end
            end
            % Y is i excluded average 
            Y = X./(SubNum-1);
           
            % Update Orthogonal matrix with BrainSync projection technique
            [U, ~, V] = svd(Y * S(:, :, i)'); 
            Os(:, :, i) = U * V';       
        end
        
        disp('calculate error');
        Error = 0;
        % New Average with all subject updated orthogonal matrix
            % update last subject outside loop
        X2 = (X + Os(:, :, i) * S(:, :, i))./SubNum;
        
        % Calculate error of all subjects from average map
        for j = 1:SubNum
            etemp = Os(:, :, j) * S(:, :, j) - X2;
            Error = Error + trace(etemp*etemp'); %calculating error
        end
        
        
        
        
        relcost = abs(Error - PreError) ./ abs(InError);    
        Costdif(var) = PreError - Error;
        PreError=Error;
       
        var
        relcost
    end
    
    Costdif(var+1:end) = [];
    Costdif = Costdif(2:end);
    TotalError = Error;
    
end