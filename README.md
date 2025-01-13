# **README for Graph Cycle Analysis Script**

## **Overview**
This script is designed to process a graph represented by its adjacency matrix, identify all cycles of a specified length range, and generate a matrix \( B_2 \) that encodes cycle-edge relationships. Additionally, the script provides tools to visualize the graph and highlight cycles with specific properties, such as circulation.

The script can be used to generate \( B_2 \), save it in `.mat` format, and use it as input for other analyses (e.g., with the R script mentioned).

---

## **How the Script Works**

### **1. Loading and Preprocessing**
- **Input:** The adjacency matrix \( A \) is loaded from a `.mat` file and converted to a MATLAB `graph` object.
- The `graph` object allows access to high-level operations, such as cycle detection and edge manipulation.

---

### **2. Cycle Detection**
The script identifies all cycles in the graph using the `allcycles` function:
- **Minimum Cycle Length:** 3 (to avoid trivial loops or edges).
- **Maximum Cycle Length:** User-defined; set in the `allcycles` function.

Each cycle is stored as a list of node indices.

---

### **3. Sorting and Edge Representation**
- **Cycle Sorting:** Cycles are sorted by their length to facilitate structured analysis.
- **Edge Representation:**
  - Each cycle is transformed into an ordered list of edges, ensuring consistency in edge directionality.
  - Edges are stored in two ways:
    1. **Ordered edges:** Edges are sorted lexicographically.
    2. **Directed edges:** Edges retain their original order in the cycle.

---

### **4. Construction of \( B_2 \) Matrix**
- The \( B_2 \) matrix represents the relationship between cycles and edges:
  - Rows correspond to edges in the graph.
  - Columns correspond to detected cycles.
  - Entry \( B_2(i,j) \):
    - \( +1 \) if the edge is part of the cycle with the same orientation.
    - \( -1 \) if the edge is part of the cycle with opposite orientation.
    - \( 0 \) if the edge is not part of the cycle.

---

### **5. Column Reduction and Filtering**
- The script uses the Reduced Row Echelon Form (RREF) of the \( B_2 \) matrix to identify linearly independent cycles.
- Independent cycles are selected to form the final \( B_2 \) matrix, eliminating redundant cycles.
- Indices of the selected cycles are used to extract valid cycle subsets.

---

### **6. Visualization**
- The graph is plotted, and nodes and edges are highlighted for clarity.
- Cycles are visualized with colors proportional to random vector values (used as a stand-in for circulation or other metrics).
- **Color Map:** A `parula` colormap is used to represent the magnitude of the circulation values.

---

## **File Descriptions**
- `A (1).mat`: Input adjacency matrix (saved as a variable `A`).
- `B2`: Matrix encoding the cycle-edge relationships.
- `selected_cells`: Cell array containing the node lists for independent cycles.

---

## **Functions**
### **1. `to_edge(loop)`**
- Converts a loop (cycle) into a list of directed edges.

### **2. `index(cell, arr)`**
- Searches for an edge in a list of edges and returns its index.

### **3. `check_self(loop)`**
- Verifies if a loop is self-contained (i.e., a single node).

---

## **Dependencies**
- MATLAB R2018b or later.
- `graph` and `digraph` functions.

---

## **Usage Instructions**
1. **Prepare the Adjacency Matrix:**
   - Save the adjacency matrix \( A \) as a `.mat` file with the variable name `A`.

2. **Run the Script:**
   - Modify the `allcycles` function to specify the desired minimum and maximum cycle lengths.
   - Execute the script in MATLAB.

3. **Extract Results:**
   - \( B_2 \): Final cycle-edge incidence matrix.
   - `selected_cells`: Independent cycles extracted based on RREF.

4. **Visualize:**
   - The script automatically generates a plot of the graph and highlights the cycles.

---

## **Algorithm Summary**
1. **Graph Representation:**
   - Load adjacency matrix and convert it into a `graph` object.

2. **Cycle Detection:**
   - Find all cycles of lengths within the specified range.

3. **Cycle Sorting:**
   - Sort cycles by length and structure.

4. **Cycle-Edge Matrix Construction (\( B_2 \)):**
   - Map edges to cycles and determine their orientation.

5. **Column Reduction:**
   - Reduce the matrix to identify independent cycles.

6. **Visualization:**
   - Plot the graph and overlay cycle information.

---

## **Applications**
- **Network Analysis:** Identify fundamental cycles in networks.
- **Graph Theory Research:** Study cycle properties and topological relationships.
- **Circuit Analysis:** Analyze current flow or circulation in electrical networks.
- **Visualization:** Explore graph structures interactively.

---

## **Customization**
- **Cycle Length Range:** Modify `MinCycleLength` and `MaxCycleLength` in the `allcycles` function.
- **Random Vector:** Replace the random vector used for visualization with any property of interest (e.g., circulation or weight).

---

Feel free to adapt the script to your specific needs and extend its functionality as required.
