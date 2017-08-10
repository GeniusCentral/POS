# POS Starter Scripts
POS Starter Scripts for integration with Genius Central Ordering Services

## Get Started
1. **Pre-requisites** - These scripts are intended to run in PowerShell on Windows

2. **Clone or Download the Repository**
    * [Clone] If you have git tools installed, run this command to create a folder called POSScripts and place the code in the folder:
    `git clone https://github.com/GeniusCentral/POS.git POSScripts`
    * [Download] Alternatively, click "Clone or download" in the top right hand corner of the repository, and Download the Zip file into a folder called "POSScripts"

2. **Sending TEST Orders**
    * Open a PowerShell window
    * Run `.\SendOrders true`
        * The `true` flag indicates that we are in test mode
    * On first run, you should see folder created messages
    * Open the LogFiles folder and confirm that you have a log file and that the log file indicates that Orders were sent

3. **Getting Orders using TEST account**
    * Run `.\GetOrders`
    * On first run, you should see folder created messages
    * Open the LogFiles folder and confirm that the log file indicates that we attempted to Get Orders
    * There may not actually be any orders to download

4. **Getting Invoices using TEST account**
    * Run `.\GetInvoices`
    * On first run, you should see folder created messages
    * Open the LogFiles folder and confirm that the log file indicates that we attempted to Get Invoices
    * There may not actually be any invoices to download

5. **Change the configuration file to match your unique configuration**
    * Genius Central will provide you with the changes and values to update

6. **Complete Setup with Genius Central**
    * Production, Scheduling

For support, please contact possupport@geniuscentral.com or 941.xxx.yyyy


