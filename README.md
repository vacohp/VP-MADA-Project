## Project structure

-   The data can be located in the data folder with sub-folders for raw data and processed data.

-   The code can be located in the code folder with various sub-folders

-   The results can be located in the figures folder with sub-folders for figures, tables, and computed values

-   The manuscripts and supplementary materials are located in the products folder

-    There is a README file located in each folder with short summaries of what is in its respective folder and any additional information

## Instructions for reproduction

### Data loading and processing

Go to `Code` \> `processing_code` and locate the `processing_code.qmd` file and run the entire script. This will save all necessary output files that you will need to load for the exploratory analysis.

### Exploratory analysis

Go to `Code` \> `analysis_code` and locate the `exploratory_analysis.qmd` file. This will create figures of simple analysis of the processed data.

### Manuscript

To look at the manuscript file, please go to `products` \> `manuscript` \> `Manuscript.html` and download the .html file.

To reproduce the `Manuscript.qmd`, you will first need to run `processing.qmd` and `exploratory_analysis.qmd`. This will allow you to produce the tables and figures associated with the manuscript.
