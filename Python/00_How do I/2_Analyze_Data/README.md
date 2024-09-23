# How to Analayze Data

- Arch | WSL2 Arch
- Install packages

```bash
sudo pacman -S python python-pip polars jupyter-notebook jupyter-lab ipython python-matplotlib python-seaborn python-pandas python-numpy python-scikit-learn python-tqdm python-requests

pip install -U polars matplotlib seaborn pandas numpy scikit-learn datasets plotly ipywidgets tqdm requests huggingface_hub pyarrow altair bokeh openpyxl xlrd

```

- Log in to your Hugging Face account using the CLI:

```bash
huggingface-cli login
```

- Download a dataset (we'll use a solar energy dataset)

```bash
huggingface-cli download openclimatefix/uk_pv --repo-type dataset --local-dir uk_pv_data
```

- From your home directory, set a jupyter lab instance

```bash
jupyter lab
```

- Open the .py and .ipynb files
- Setup your jupyterlab instance to run the cells

```bash
import polars as pl
import matplotlib.pyplot as plt
import seaborn as sns

df = pl.read_parquet("uk_pv_data/5min.parquet")

# Display basic information about the dataset
print(df.head())
print(df.shape)
print(df.dtypes)

# Calculate summary statistics
print(df.describe())

# Convert to pandas for easier plotting with seaborn
pdf = df.to_pandas()

# Set up the plot style
plt.figure(figsize=(12, 6))
sns.set_style("whitegrid")

# Plot the solar generation for a single system over time
single_system = pdf[pdf['ss_id'] == pdf['ss_id'].unique()[0]]
sns.lineplot(x='timestamp', y='generation_wh', data=single_system)
plt.title("Solar Generation for a Single System")
plt.xlabel("Timestamp")
plt.ylabel("Generation (Wh)")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# Plot the distribution of generation values
plt.figure(figsize=(10, 6))
sns.histplot(pdf['generation_wh'], kde=True)
plt.title("Distribution of Solar Generation")
plt.xlabel("Generation (Wh)")
plt.ylabel("Frequency")
plt.show()

# Plot average generation by hour of day
pdf['hour'] = pdf['timestamp'].dt.hour
hourly_avg = pdf.groupby('hour')['generation_wh'].mean().reset_index()
plt.figure(figsize=(10, 6))
sns.barplot(x='hour', y='generation_wh', data=hourly_avg)
plt.title("Average Solar Generation by Hour of Day")
plt.xlabel("Hour of Day")
plt.ylabel("Average Generation (Wh)")
plt.show()

# Calculate daily total generation for each system
daily_totals = df.groupby(['ss_id', pl.col('timestamp').dt.date()]).agg(
    pl.col('generation_wh').sum().alias('daily_total')
)

# Find the top 5 systems with the highest average daily generation
top_systems = daily_totals.groupby('ss_id').agg(
    pl.col('daily_total').mean().alias('avg_daily_total')
).sort('avg_daily_total', descending=True).head(5)

print("Top 5 systems by average daily generation:")
print(top_systems)

```

- Review the solar_analysis jupyter notebook and solar_analysis.py

```bash
# Cell 1: Import libraries
import polars as pl
import matplotlib.pyplot as plt
import seaborn as sns

# Cell 2: Load data
df = pl.read_parquet("uk_pv_data/5min.parquet")

# Cell 3: Display basic information
print(df.head())
print(df.shape)
print(df.dtypes)

# Cell 4: Calculate summary statistics
print(df.describe())

# Cell 5: Convert to pandas and plot
pdf = df.to_pandas()

plt.figure(figsize=(12, 6))
sns.set_style("whitegrid")

single_system = pdf[pdf['ss_id'] == pdf['ss_id'].unique()[0]]
sns.lineplot(x='timestamp', y='generation_wh', data=single_system)
plt.title("Solar Generation for a Single System")
plt.xlabel("Timestamp")
plt.ylabel("Generation (Wh)")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
```

```bash
import polars as pl
import matplotlib.pyplot as plt
import seaborn as sns

def main():
    # Load data
    df = pl.read_parquet("uk_pv_data/5min.parquet")

    # Display basic information
    print("Dataset Head:")
    print(df.head())
    print("\nDataset Shape:", df.shape)
    print("\nDataset Data Types:")
    print(df.dtypes)

    # Calculate summary statistics
    print("\nSummary Statistics:")
    print(df.describe())

    # Convert to pandas and plot
    pdf = df.to_pandas()

    plt.figure(figsize=(12, 6))
    sns.set_style("whitegrid")

    single_system = pdf[pdf['ss_id'] == pdf['ss_id'].unique()[0]]
    sns.lineplot(x='timestamp', y='generation_wh', data=single_system)
    plt.title("Solar Generation for a Single System")
    plt.xlabel("Timestamp")
    plt.ylabel("Generation (Wh)")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig("solar_generation_plot.png")
    print("Plot saved as solar_generation_plot.png")

if __name__ == "__main__":
    main()
```
