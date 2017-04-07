%%%%% Matrice adjacente du graphe orient� pr�sent� dans l'exemple du .lyx
M=[0 1 0 0 0 0 0 0;
   0 0 1 0 0 0 0 0;
   0 0 0 1 0 0 0 0;
   0 0 0 0 1 0 1 0;
   0 0 0 0 0 1 0 0;
   1 0 0 0 0 0 1 0;
   0 0 0 0 1 0 0 1;
   1 0 0 0 0 0 0 0];

%%%%% Cycles de taille 1
M==M'

%%%%% Pour la r�duction du graphe... je recherche les noeuds qui n'ont
%%%%% qu'un arc entrant et qu'un arc sortant pour les �liminer

% noeuds dont les arcs entrants = arcs sortants = 1
r=(sum(M').*sum(M))==1
% arcs sortants
r_out=diag(r)*M
% arcs entrants
r_in=diag(r)*M'
