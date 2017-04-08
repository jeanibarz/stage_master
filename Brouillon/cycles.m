%%%%% Matrice adjacente du graphe orient� pr�sent� dans l'exemple du .lyx
M=[0 1 0 0 0 0 0 0;
   0 0 1 0 0 0 0 0;
   0 0 0 1 0 0 0 0;
   0 0 0 0 1 0 1 0;
   0 0 0 0 0 1 0 0;
   1 0 0 0 0 0 1 0;
   0 0 0 0 1 0 0 1;
   1 0 0 0 0 0 0 0];

%% Voisins de +2/-1 �v�nement
M|M^2|M'

%% Cycles de taille 1
eye(8,8).*M

%% Cycles de taille 1 ou 2
M&M' % �quivalent � M.*M' car on est en bool�en

%% Pour la r�duction du graphe... je recherche les noeuds qui n'ont
% qu'un arc entrant et qu'un arc sortant pour les �liminer

% noeuds dont les arcs entrants = arcs sortants = 1
r=(sum(M').*sum(M))==1 % complexit� O(N^2) (probablement r�ductible)
% arcs sortants
r_out=diag(r)*M % complexit� O(N)
% arcs entrants
r_in=diag(r)*M' % complexit� O(N)
M(:,r)

%% Sch�ma d'exponentiation binaire...
M2=(eye(8,8)+M+M^2)>0;
M4=M2^2>0;
M8=M4^2>0;
M16=M8^2>0;
M32=M16^2>0;
M64=M32^2>0;
Mexp=M4-eye(8,8)
Mbis=(M>0|M^2>0|M^3>0|M^4>0)&(~eye(8,8))