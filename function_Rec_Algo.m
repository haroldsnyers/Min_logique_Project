function URP = function_Rec_Algo(list, nbrvar) % parameter (list, size of a row)
  % --STEP 1 : case - empty list--
  if (isempty(list)) % if empty f = 0
    % complement of f : f' = 1 which is a list with only 3
    URP = 3*ones(1,nbrvar); % makes a list of size nbrvar with only 3
    return 
  endif
  
  % --STEP 2 : case - cube all don't care--
  % if function has a all don't care cube, then f=1, the complement of that is 
  % f' = 0 which is represented by an empty list
  for i = 1:rows(list) % go through each row 
    if (sum(list(i,:)) == 3*nbrvar) 
    %sums up each elem of that row and verifies if it's equal to 3 times the row 
    %length. A cube of all don't care is only with elem = 3 so sum = 3*Lenght
      URP = []; 
      return
    endif
  endfor
  
  % --STEP 3 : case - 1 cube only--
  % function contains only one cube, we can use the laws of Demorgan to 
  % complement
  if (rows(list) == 1)
    a = [];
    for i=1:columns(list)
      if (!(list(1,i) == 3))
        tmp = 3*ones(1,nbrvar); % row of size nbrvar with only elements = to 3
        % for loop to modify in consequence tmp
        if (list(1,i) == 1) %complement of 1 is 2
          tmp(1,i) = 2;
        elseif (list(1,i) == 2)  % complement of 2 is 1
          tmp(1,i) = 1;  
        endif
        a = [a;tmp]; % adds up the tempory list to a, the matrix complement
      endif
    endfor
    if (!(isempty(a))) % in case but normally not necessary because of step 2
      URP = a;
      return
    endif
    
  % --STEP 4 : case - not one of above cases--
  else
    % determination of the index of the variable we will be working on
    % initialisation variables
    x_indexM = 0;
    x_indexB = 0;
    x_nbrM = 0;
    x_nbrB = 0;
    biminR = 0;
    for i = 1:columns(list) %loop through the columns of the matrix
      nbr1=0;
      nbr2=0;
      for j = 1:rows(list) % loop through the rows of the column we are working on
        if (list(j,i)==1) % counting number of 1 there is in that column
          nbr1 += 1;
        elseif (list(j,i) == 2) % counting number of 2 there is in that column
          nbr2 += 1;
        endif
      endfor
      if ((nbr1 == 0 && nbr2 > 0) || (nbr1 > 0 && nbr2 == 0)) % if unate
        nbr_sum = nbr1 + nbr2;
        if (nbr_sum > x_nbrM) % assignin most unate variable
          x_nbrM = nbr_sum;
          x_indexM = i;
        endif
      elseif (nbr1 > 0 && nbr2> 0) % if binate 
        nbr_sum= nbr1 + nbr2;
        bimin = abs(nbr1-nbr2); 
        if (nbr_sum >= x_nbrB) % assignin most binate variable
          if (nbr_sum == x_nbrB) % column with same amount of 3
            if (bimin < biminR) % checks if column more balanced 
              x_nbrB = nbr_sum;
              x_indexB = i;
              biminR = bimin;
            endif
          else % column with fewer 3, more 2 and 1
            x_nbrB = nbr_sum;
            x_indexB = i;
            biminR = bimin;
          endif
        endif  
      endif
    endfor
    if (x_indexB == 0) % if there is no binate column, we take unate index
      x_indexB = x_indexM;
    endif
    % determination of the cofactors
    co_fac_P = [];
    co_fac_N = [];
    for i=1:rows(list) % loop through each row
      if (list(i,x_indexB)== 1) 
        % if that variable equals 1, for the pos cofactor, we must change it to
        % 3 (for x = 1, if xyz then we obtain yz); for the negative cofactor we 
        % must leave it out (for x = 1, if x'yz then we obtain 0)
        tmp_row = list(i,:);
        tmp_row(1,x_indexB) = 3;
        co_fac_P = [co_fac_P;tmp_row];
      elseif (list(i,x_indexB)== 2)
        % if that variable equals 2, for the neg cofactor, we must change it to
        % 3 (for x = 0, if x'yz then we obtain yz); for the positive cofactor we 
        % must leave it out (for x = 1, if xyz then we obtain 0)
        tmp_row = list(i,:);
        tmp_row(1,x_indexB) = 3;
        co_fac_N = [co_fac_N;tmp_row];
      else
        % if that variable equals 3, for the pos cofactor and for negatiive 
        % cofactor we must leave them be (for x = 1/0, if yz then we obtain yz)
        tmp_row = list(i,:);
        co_fac_P = [co_fac_P;tmp_row];
        co_fac_N = [co_fac_N;tmp_row];
      endif
    endfor
    % determiantion of the complement
    co_fac_N = function_Rec_Algo(co_fac_N, nbrvar); % recursive call 
    co_fac_P = function_Rec_Algo(co_fac_P, nbrvar); % recursive call
    for i=1:rows(co_fac_N) % setting all members of the column at index x to 2
      % which means doing an AND for x denied
        co_fac_N(i,x_indexB) = 2;
    endfor
    for i=1:rows(co_fac_P) % setting all members of the column at index x to 1
    %which mean doing an AND for x not denied
        co_fac_P(i,x_indexB) = 1;
    endfor
    %the complement is obtained by doing an OR, which is the same as concatenate 
    URP = [co_fac_P;co_fac_N]; 
    return
  endif
endfunction
