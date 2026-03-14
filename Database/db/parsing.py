from pathlib import Path
import pandas as pd

folder = Path("../Data")

all_dfs = []

for file in folder.rglob("*.csv"):
    df = pd.read_csv(file)

    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    filename = file.stem
    parts = filename.split(" - ")

    season = parts[0].split("-")[1]
    team = parts[1]

    df["season"] = int(season)
    df["team"] = team

    all_dfs.append(df)

master_df = pd.concat(all_dfs, ignore_index=True)

master_df.to_csv("../Data/wnfc_player_stats_master.csv", index=False)