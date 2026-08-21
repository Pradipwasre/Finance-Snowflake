# Snowflake + Python + ML Project

A classroom project connecting **Snowflake (SQL)** with **Python (VS Code)** to fetch data, explore it with pandas, and prepare it for upcoming **Statistics / ML / Streamlit** sessions.

---

## 📁 Project Structure

```
Finance-Snowflake/
│
├── finance_ml_regression_dataset.sql   # Already run on Snowflake — creates the table
├── requirements.txt                    # Python dependencies
├── connection.py                       # Connects VS Code → Snowflake, fetches data
├── analysis.ipynb                      # Pandas check on the fetched data
└── README.md                           # This file
```

Snowflake objects already created (via the `.sql` file):
- **WAREHOUSE**: `FINANCE_ML_WH`
- **DATABASE**: `FINANCE_ML_DB`
- **SCHEMA**: `FINANCE_PROJECTS`
- **TABLE**: `FINANCE_PROJECTS_ML_DATA` (10,000 rows)

---

## 🚀 Setup Guide

### Step 1: Create a virtual environment

A virtual environment keeps this project's Python packages isolated from everything else on your system — standard practice in real data engineering work.

**🍎 Mac (Terminal inside VS Code):**
```bash
python3 -m venv venv
source venv/bin/activate
```

**🪟 Windows (PowerShell inside VS Code):**
```powershell
python -m venv venv
venv\Scripts\Activate.ps1
```

> If Windows blocks the script with an execution policy error, run this once:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

✅ You'll know it's active when you see `(venv)` at the start of your terminal line.

---

### Step 2: Install dependencies from `requirements.txt`

With `(venv)` active, run:
```bash
pip install -r requirements.txt
```

This installs `snowflake-connector-python`, `pandas`, `notebook`, `ipykernel`, and everything else needed for this project.

---

### Step 3: Run the project

**Run the connector script:**
```bash
python connection.py
```

You'll be prompted:
```
Enter your Snowflake password:
```
Type your password (it won't show on screen — that's normal) and press Enter.

This will:
1. Connect to Snowflake using your account/user/warehouse/database/schema
2. Fetch all rows from `FINANCE_PROJECTS_ML_DATA` into a pandas DataFrame
3. Print `df.head(10)` as a quick check
4. Close the connection

**Or run the notebook instead:**
- Open `analysis.ipynb` in VS Code
- Select the `venv` Python interpreter as the kernel (top-right of the notebook)
- Run the cells top to bottom — same result, interactively

---

## 🧠 Key Concept for Students

> **Snowflake = permanent storage** (data always lives there)
> **VS Code / pandas DataFrame = temporary workspace** (memory only)

If you restart VS Code, your system, or the Jupyter kernel — the DataFrame disappears. Just re-run `connection.py` or the notebook cells to fetch it again. This is normal, and mirrors how real data engineers work.

---

## 🗺️ Roadmap — What's Next

| Session | Topic |
|---|---|
| ✅ Today | Snowflake ↔ Python connection, pandas check |
| 🔜 Next | **Statistics** — deep dive into this same `df` |
| 🔜 After | **Machine Learning** — train Linear Regression / Random Forest on `ACTUAL_PROJECT_COST` |
| 🔜 Final | **Streamlit** — build a UI where users input project features and get a predicted cost |

---

## ⚠️ Troubleshooting

| Issue | Fix |
|---|---|
| `ModuleNotFoundError` | Make sure `(venv)` is active before running scripts |
| `keyring` warning on run | Harmless — ignore, or fix with `pip install "snowflake-connector-python[secure-local-storage]"` |
| SAML/externalbrowser auth error (`390190`) | Your Snowflake account has no SSO configured — use username/password login instead (already set up in `connection.py`) |
| Notebook uses wrong Python | Reselect the kernel: `Ctrl+Shift+P` → `Python: Select Interpreter` → choose the one inside `venv/` |