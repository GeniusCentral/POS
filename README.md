# POS Starter Scripts
POS Starter Scripts for integration with Genius Central Ordering Services

## Prerequisites
These scripts are intended to run in PowerShell on Windows

## Get Started
1. **Clone or Download the Repository**
    * [Clone] If you have git tools installed, run this command to create a folder called POSScripts and place the code in the folder:
    `git clone https://github.com/GeniusCentral/POS.git POSScripts`
    * [Download] Alternatively,in this github repository click "Clone or download" in the top  corner and download the zip file into a folder called "POSScripts"

2. ** Set up permission to run these PowerShell scripts
    * Open a PowerShell window as an Administrator
    * Execute the command Set-ExecutionPolicy RemoteSigned

3. **Send TEST Orders**
    * Make sure you are in the POSScripts folder
    * Run `.\SendOrders -test true`
        * The `-test true` indicates that we are in test mode
    * On first run, you should see folder created messages
    * Open the LogFiles folder and confirm that you have a log file and that the log file indicates that Orders were sent

4. **Get Orders using TEST account**
    * Run `.\GetOrders`
    * On first run, you should see folder created messages
    * Open the LogFiles folder and confirm that the log file indicates that we attempted to Get Orders
    * There may not actually be any orders to download

5. **Get Invoices using TEST account**
    * Run `.\GetInvoices`
    * On first run, you should see folder created messages
    * Open the LogFiles folder and confirm that the log file indicates that we attempted to Get Invoices
    * There may not actually be any invoices to download

6. **Change the configuration file to match your unique configuration**
    * Genius Central will provide you with the changes and values to update

7. **Complete Setup with Genius Central**
    * Set debug=false in .config
    * Set outputToConole=false in .config if that is your preference
    * Test with your specific configuration
    * Test in Production with your specific configuration





