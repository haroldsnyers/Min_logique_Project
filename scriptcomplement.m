% --STEP 1 : case - Empty list--
listvide_f = dlmread('etape1OK.cubes');
nbrvar_vide = 5;
URP = function_Rec_Algo(listvide_f, nbrvar_vide);

% --STEP 2 : case - Cube all don't care--
list_Dcare_f = dlmread('etape2OK.cubes');
nbrvar_Dcare_f = columns(list_Dcare_f);
URP = function_Rec_Algo(list_Dcare_f, nbrvar_Dcare_f);

% --STEP 3 : case - 1 cube only--
list_1cube_f = dlmread('etape3OK.cubes');
nbrvar_1cube_f = columns(list_1cube_f);
URP = function_Rec_Algo(list_1cube_f, nbrvar_1cube_f);

% --STEP4 : case - not above--
list_cofac_2 = dlmread('etape4mono.cubes');
nbrvar_cofac_2 = columns(list_cofac_2);
URP = function_Rec_Algo(list_cofac_2, nbrvar_cofac_2);

tic
list_cofac_1 = dlmread('fonctionA.cubes');
nbrvar_cofac_1 = columns(list_cofac_1);
URP = function_Rec_Algo(list_cofac_1, nbrvar_cofac_1);
toc

%tic 
list_cofac_2 = dlmread('function1.cubes');
nbrvar_cofac_2 = columns(list_cofac_2);
URP = function_Rec_Algo(list_cofac_2, nbrvar_cofac_2);
%toc

