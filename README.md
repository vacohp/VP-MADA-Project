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

### Model fitting

Go to `code` \> `modeling_code` \> `data_splitting.Rmd` first to split the data into train and test sets before running the rest of the scripts.

Each file ending in "model.Rmd" runs a script that fits and evaluates a model for each combination of predictor and outcome.

### Manuscript

To look at the manuscript file, please go to `products` \> `manuscript` \> `Manuscript.html` and download the .html file. I will change this back to a .docx file in the future, but for editing purposes I will have it saved as a .html.

To reproduce the `Manuscript.qmd`, you will first need to run `processing.qmd` and `exploratory_analysis.qmd`. This will allow you to produce the tables and figures associated with the manuscript.
