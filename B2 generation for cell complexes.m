clear all;
clc;
close all;


%Con questo file viene generata B2 completa di tutti i cicli, da scaricare dal Workspace nel formato di 
%default ".mat" utilizzare poi come
%input dello script R. 
%in allcycles bisogna inserire 3 come lunghezza minima, per la lunghezza
%massima bisogno inserire il valore relativo alla massima lunghezza dei
%cicli che si vuole ottenere. 

%% step 1 
A= load('A (1).mat');
A = A.A;
A = double(A);
G = graph(A);
cycles = allcycles(G, 'MinCycleLength',3,'MaxCycleLength', 10);
%scegliere il numero massimo di lunghezza per cicli 


%% Step 2
for i=1:length(cycles)
    cycles{i} = unique(cycles{i},'stable');
   
end
% %
% % %sort cycles
[~,I] = sort(cellfun(@length,cycles));
cycles = cycles(I);
% % 
% % %creazione della lista con edges ordinati (es: (1,2) (2,3) (1,2))
edges_ordered = {};
for lis = 1: length(cycles)
  lis_edge = {}; 
  for i = 1:(length(cycles{lis})-1)
    e = sort([cycles{lis}(i),cycles{lis}(i+1)]);
    lis_edge{i} = e;
  end
  lis_edge{i+1} = sort([cycles{lis}(1),cycles{lis}(end)]);
  edges_ordered{lis} = lis_edge;
end
% 
% 
% %creazione lista con edges in senso crescente (es: (1,2) (2,3) (3,1))
cycles_edges = {}
for i= 1:length(cycles)
    cycles_edges{i} = to_edge(cycles{i});
end


edge_list = table2cell(G.Edges);

B2 = zeros(length(edge_list),length(cycles));


for loop = 1:length(edges_ordered)
  for edge = 1:length(edges_ordered{loop})
    if isequal(edges_ordered{loop}{edge},cycles_edges{loop}{edge})
        B2(index(edge_list,edges_ordered{loop}{edge}),loop) = 1;
    else
        B2(index(edge_list,edges_ordered{loop}{edge}),loop)= -1;
    end
  end
end 
%end

%% Step 3

% Carica i dati

mat = B2;

% Conta quanti valori non nulli ha ciascuna colonna
nnz_per_col = sum(mat ~= 0, 1);

% Ordina le colonne in base al numero di non nulli (crescente)
[~, idx_sorted] = sort(nnz_per_col, 'ascend');

% Riordina la matrice in base a questo nuovo ordine
mat_sorted = mat(:, idx_sorted);

% Calcola la forma a scalini ridotta della matrice ordinata
[Rs, pivotcols] = rref(mat_sorted);

% 'pivotcols' contiene gli indici delle colonne pivot nella matrice ordinata
% Queste colonne sono linearmente indipendenti e mantengono l'ordine
% che abbiamo impostato (prima colonne con 3 non nulli, poi con 4, ecc.)
mmat = mat_sorted(:, pivotcols);

% Se necessario, recupera gli indici delle colonne nella matrice originale
original_indices = idx_sorted(pivotcols);

%B2 finale

B2_final = B2(:, original_indices);
[n_edge,n_tri] = size(B2_final);

%% prendo le celle valide

selected_cells = cycles(original_indices); % Ottieni le celle corrispondenti
%selected_rows_cell2mat = vertcat(selected_cells{:}); % Converti in matrice


%% plot 

random_vector = rand(1,n_tri); % vettore riga con n_tri valori casuali tra 0 e 1
norm_min = min(random_vector);
norm_max = max(random_vector);
if norm_min == norm_max
    normalized_norms = ones(size(triangoli, 1), 1); % Avoid division by zero
else
    normalized_norms = (random_vector - norm_min) / (norm_max - norm_min);
end

% Plot the graph
h = plot(G);
hold on; % Keep adding to the same figure

% Extract coordinates
x = h.XData;
y = h.YData;

% Plot the edges
[row, col] = findedge(G); % Ensure row and col are extracted from G

% Fill the triangles with color based on circolazione
if ~isempty(random_vector)
    colormap('parula'); % Use a colormap for the triangles
    for i = 1:size(selected_cells, 1)
        tri_nodes = selected_cells(i, :); % Triangle node indices
        fill(x(tri_nodes{1}), y(tri_nodes{1}), random_vector(i), 'FaceAlpha', 0.8, 'EdgeColor', 'none');
    end

    % Add colorbar
    caxis([norm_min norm_max]);
    colorbar;
end
E = numel(row); % Number of edges
for i = 1:E
    plot([x(row(i)), x(col(i))], [y(row(i)), y(col(i))], 'k', 'LineWidth', 2);
end


% Plot the nodes on top of the triangles
node_size = 200; % Increase node size for better visibility
scatter(x, y, node_size, 'filled', 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);

% Label the nodes on top of the triangles
for i = 1:numel(x) % Number of nodes
    text(x(i), y(i), num2str(i), 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
end

% Set axes and clean up
axis equal;
axis off;
hold off;













%if ~any(strcmp(edge_list,edges_ordered{loop}{edge}))

function final = to_edge(loop)
final = {};
loop = [loop,loop(1)];
for i = 1:(length(loop)-1)
    final{i} = [loop(i),loop(i+1)];
end
end

function idx = index(cell, arr)
idx = 1;
for i= 1:length(cell)
    if isequal(cell{i},arr)
        idx = i;
    end
end
end


function is_self = check_self(loop)
is_self = 0
count = 0
for i=1:(length(loop)-1)
    if loop(i) == loop(i+1)
        count = count+1
    end
if count == length(loop)-1
    is_self = 1
end
end
end






