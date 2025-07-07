import pandas as pd
import numpy as np
import tskit
import pyslim
from math import sqrt
from itertools import combinations
import random

# === PARAMETERS ===
site_coords = {
    "Cape_May_NJ":      (938, 324),
    "Newport_RI":       (680, 498),
    "Beverly_MA":       (636, 637),
    "Kettle_Cove_ME":   (525, 700),
    "Robbinston_ME":    (380, 763)
}
radius = 20
sample_size = 20
tree_file = "out_0.0.trees"
csv_file = "spatial_0.0.csv"
pos_tolerance = 5.0  # tolerance in spatial matching between CSV and .trees

# === LOAD DATA ===
df = pd.read_csv(csv_file)
adults = df[df["stage"] == "adult"].copy()

def dist_to_site(row, center):
    return sqrt((row["x"] - center[0])**2 + (row["y"] - center[1])**2)

# === LOAD TREE SEQUENCE ===
ts = tskit.load(tree_file)
ts = ts.simplify()

# === MATCH CSV ADULTS TO TREE INDIVIDUALS BY SPATIAL POSITION ===
# Build mapping from CSV to individual IDs in .trees
csv_to_ind_id = {}
for csv_idx, row in adults.iterrows():
    csv_x, csv_y = row["x"], row["y"]
    for ind in ts.individuals():
        if ind.flags & 1:  # alive
            loc = ind.location
            if abs(loc[0] - csv_x) <= pos_tolerance and abs(loc[1] - csv_y) <= pos_tolerance:
                csv_to_ind_id[csv_idx] = ind.id
                break

# === SAMPLE INDIVIDUALS PER SITE ===
sample_sets = {}
for site, center in site_coords.items():
    # Calculate distance to center
    adults["dist"] = adults.apply(lambda row: dist_to_site(row, center), axis=1)
    nearby = adults[(adults["dist"] <= radius) & (adults.index.isin(csv_to_ind_id.keys()))]
    if len(nearby) < 2:
        print(f"{site}: only {len(nearby)} matched adults — skipping")
        sample_sets[site] = []
        continue
    sampled = nearby.sample(n=min(sample_size, len(nearby)), random_state=42)
    # Get node IDs
    nodes = []
    for idx in sampled.index:
        ind_id = csv_to_ind_id[idx]
        nodes.extend(ts.individual(ind_id).nodes)
    sample_sets[site] = nodes
    print(f"{site}: using {len(nodes)} nodes from {len(sampled)} individuals")

# === CALCULATE PAIRWISE FST ===
site_names = list(site_coords.keys())
fst_matrix = pd.DataFrame(index=site_names, columns=site_names, dtype=float)

for i, j in combinations(site_names, 2):
    s1, s2 = sample_sets[i], sample_sets[j]
    if len(s1) >= 2 and len(s2) >= 2:
        fst = ts.Fst([s1, s2], mode="site")
    else:
        fst = np.nan
    fst_matrix.loc[i, j] = fst
    fst_matrix.loc[j, i] = fst

np.fill_diagonal(fst_matrix.values, 0.0)

# === OUTPUT ===
print("\nPairwise FST matrix (adults only):")
print(fst_matrix.round(4))
fst_matrix.to_csv("pairwise_fst_adults.csv")



# calc FST 
