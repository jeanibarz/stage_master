A=[0.7 0.2; 0 0.5];
B=[0;1];
C=eye(2,2);
C1=C(1,:);
C2=C(2,:);

% SORTIE 1
H12=[C1; C1*A; C1*A^2];

% Decomposition de la partie pleine et redondante de H12
H121=H12(1:2,:);
H122=H12(3,:)

OMEGA1=-[H122*inv(H121) -1]; % OMEGA + ou - c'est pareil...
% Remarque: on peut vérifier que OMEGA*H12 = 0

% Vecteur de parité (forme de calcul)
G1=[0; C1*B; C1*A*B];


% SORTIE 2
H22=[C2; C2*A; C2*A^2];

H221=H22(1,:);
H222=H22(2,:);

OMEGA2=[-1 2 0]; % une des infinites de possibilites...

% Vecteur de parité (forme de calcul)
G2=[0; C2*B; C2*A*B];

Hk21=[1 0; 0.7 0.2; 0 1];
Gk21=[0;0;0];
OMEGAk21=-[Hk21(3,:)*inv(Hk21(1:2,:)) -1];