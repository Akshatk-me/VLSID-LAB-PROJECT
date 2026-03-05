# EE 705 Course Project: Custom Multi-Cycle RV32I SoC with Parallelized SHA-256 Accelerator

Welcome to the team repository for our EE 705 VLSI Design Lab 2026 project. We are building a multi-cycle RISC-V (RV32I) processor deployed on the PYNQ-Z2 FPGA, featuring a custom SHA-256 cryptographic accelerator.

To ensure all of us can work together without overriding each other's files or breaking the Vivado project, **please read this document carefully.**

---

## Prerequisites & OS Setup

We are standardizing on **Vivado 2020.2**. Because we have team members on Arch Linux, Ubuntu, and Windows, we are using a **scripted workflow**. 

**1. Ensure Vivado is in your PATH:**
Your terminal must recognize the `vivado` command.
* **Linux (Arch/Ubuntu):** You usually need to source the settings file before working. Run this in your terminal:
  `source /tools/Xilinx/Vivado/2020.2/settings64.sh` (adjust path if you installed it elsewhere).
* **Windows:** Add the Vivado `bin` folder (e.g., `C:\Xilinx\Vivado\2020.2\bin`) to your Windows Environment Variables.

**2. Install `make`:**
* **Arch Linux:** `sudo pacman -S make`
* **Ubuntu:** `sudo apt install make`
* **Windows:** If you are using **Git Bash** (highly recommended for Windows users), you might not have `make`. You can either install it via MSYS2, or skip `make` and use the direct Vivado commands listed in the "Windows Fallback" section below.

---

## Repository Structure

```text
/RV32I_SHA256_Project
├── .gitignore             # Ignores Vivado junk (NEVER commit Vivado temp files)
├── README.md              # You are here 
├── setup_project.tcl      # The "Instant Build" script
├── /src                   # ALL your RTL code goes here
│   ├── defines.vh         # Common constants
│   ├── /core              # ALU, FSM, CSRs 
│   ├── /peripherals       # SHA256, GPIO, UART 
│   └── /mem               # BRAM logic 
├── /tb                    # All testbenches 
├── /xdc                   # PYNQ-Z2 constraints 
└── /scripts               # Helper TCL scripts
```

---

## ⚙️ How to Build and Run the Project

**DO NOT create a Vivado project manually.** Our `Makefile` and `build.tcl` script will do it for you instantly.

Open your terminal in the repository folder and use these commands:

* `make help` - Shows the list of available commands.
* `make build` - Creates or updates the project in the background (no GUI).
* `make gui` - Opens the Vivado GUI and loads/refreshes the project.
* `make clean` - Deletes the local project folder and all Xilinx junk. (Run this if things get weird).

**Windows Fallback (If `make` is not installed):**
Instead of `make gui`, run: `vivado -nolog -nojournal -mode gui -source build.tcl`
Instead of `make clean`, run: `vivado -nolog -nojournal -mode batch -source build.tcl -tclargs clean`

---

## ⚠️ The Golden Rules of Workflow

To prevent Vivado from hiding files on your local computer where Git can't see them, follow this workflow:

1. **Write Code Outside:** Create your `.v` or `.sv` files inside the `/src` folder using VS Code, Neovim, or Notepad++.
2. **Refresh Vivado:** Run `make gui`. The `build.tcl` script will automatically find your new files and link them into the Vivado project.
3. **NEVER use Vivado to create files:** Do not click "Add Sources -> Create File" in the GUI.
4. **NEVER check "Copy sources into project":** If you manually add a file via the GUI, ensure this box is unchecked.

---

## Git Crash Course (For Beginners)

We use a **Feature Branch Workflow**. Do not push directly to the `main` branch!

### 1. Getting Started (Do this once)

Clone the repository to your machine:

```bash
git clone <URL_TO_OUR_GITHUB_REPO>
cd <REPO_FOLDER_NAME>

```

### 2. Starting a New Task (Do this every time you start work)

Always make sure your local main branch is up to date, then create a new branch for your specific task.

```bash
git checkout main       # start from main
git pull origin main    # Get latest updates
git checkout -b feature/your-name-task # (e.g., git checkout -b feature/alu-design) Create AND switch to your branch

```

### 3. Saving Your Work

As you write code in the `/src` folder, save your progress to your branch.

```bash
# See what files you changed
git status 

# Stage the files you want to save
git add . 

# Commit them with a descriptive message
git commit -m "Implemented the AND/OR logic in the ALU" 

# Push your branch to GitHub
git push origin feature/your-name-task

```

### 4. Merging Your Work

When your module is done and simulated successfully:

1. Go to our GitHub repository in your web browser.
2. Click the green **"Compare & pull request"** button next to your branch.
3. Ask a teammate to review it. Once approved, it gets merged into `main`!

---

## Current Task Claims

*(Update this section as we assign tasks!)*

* **ALU & Datapath:** [Unassigned]
* **FSM FSM:** [Unassigned]
* **SHA-256 Core:** [Unassigned]
* **Memory/BRAM:** [Unassigned]
