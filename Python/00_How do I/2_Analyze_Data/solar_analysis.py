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

