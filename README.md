# COL_metagenomics

**Code notebook for analyzing samples from San Andres, Colombia**

El Arbol samples from 032024 and 012025

#### Species collection 
* DLAB - Diploria labyrinthiformis
* MCAV - Montastraea cavernosa
* OFAV - Orbicella faveolata
* PSTR - Pseudodiploria strigosa

Analysis of initial 032024 samples is in 032024_prelim repo, following a similar workflow to the one outlined below (both yrs combined)

## Workflow

### QC
0Col_qc_012025.ipynb
- Trim Galore
- Host removal (using bowtie2)
- Symbiont removal (fastq-screen)
- Re-pair reads (bbtools)

### Assembly + Mapping
1-2Col_assembly_mapping_012025.ipynb
- Concatenated samples that were re-sequenced
- Co-assemble by coral species - concatenated F and R reads for each species and assembled with megahit
- Map sample reads on to assembly (bowtie2)
- Blasted assembled contigs to probiotics database

### Binning + Taxonomic Identification
3-4Col_binning_tax_012025.ipynb
- Binning (Metabat2, Concoct, Maxbin2)
- De-replication of bins (Das Tool)
- Classification of MAGs (gtdbtk)
- Troubleshooting BAKTA for annotation
- Antismash for secondary metabolites

### MAGs
COL_MAG_cog_annotation.ipynb - see MAGs repo for figures

### Analyzing reads
**Taxonomy** \
Marine_microbe_db_with_COL_samples.ipynb : playing with other databases for read assignment \
COL_kraken_taxonomy_032024_012025_samples.ipynb : Kraken2 \
COL_bracken_032024_012025.ipynb: normalizing ASV abundances \
COL_phyloseq.ipynb: ASV phyloseq, ordination, and abundance plots \
COL_phyloseq_kingdom_tax.ipynb : kingdom abundance plots \
COL_phyloseq_family_tax.ipynb : family abundance plots \

- see Figures repo for plots made with these scripts

**Functional** \
COL_functional_analysis_012025_032024.ipynb: Humann4 troubleshooting and eventually Humann3 analysis \
COL_functional_visualization_032024_012025.ipynb: ordination and heatmaps of humann3 gene families results \
COL_pathways_plots.ipynb: looking at detected pathways from humann3 output \
COL_pathways_plots_cpm.ipynb: looking at detected pathways from humann3 output different normalization

### Misc repos
Maps : notebook and ColonyData maps for each site \
pathways + func_gene_tables : specific outputs from humann3 analysis \
Probiotic_trials.ipynb : initial analysis of field trial data

