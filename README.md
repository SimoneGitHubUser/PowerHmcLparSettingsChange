# PowerHmcLparSettingsChange
PowerHmcLparSettingsChange is a simple tool, used to change with "a single double click" IBMi Lpars settings, on HMC. It works unattended! 
It is a batch programming tool, that runs on windows operating system (extended testing on Win10, but it should work also on other Win releases).
It is very useful in case of you want to change some IBMi Lpar settings, for example os400_restricted_io_mode and redundant_err_path_reporting. These settings are requirements for Live Partition Mobility. These settings, can be modified only when Lpar is state "off".
After a simple set-up, you can schedule a power down to your IBMi Lpar, and PowerHmcLparSettingsChange will monitor for Lpar shutting down sequence, waiting still until the lpar state is "Not Activated", submit command for required setting changes, and than IPL the lpar. 
It works in unattended mode! So you can schedule the changes during the night (or when you can schedule a power off of the IBMi lpar).

## Settings check for IBMi LPM
Based on "Requirements for IBM i LPM" 
https://www.ibm.com/support/pages/requirements-ibm-i-lpm

IBMi lpars, need 2 specific advanced settings, to be checked and in case changed, before try to use LPM. 

* The property “restricted I/O” must be set on the IBM i partition.
* The IBM i partition must not be an alternative error logging partition.

PowerHmcLparSettingsChange, can manage this changes for you!

## What do you need?
* Ip address, user and passowrd of HMC
* Basic informations related to the IBMi lpar you want to modofy settings.
* plink.exe

This is all you need. 

### Initial Settings
1)  PowerHmcLparSettingsChange uses Plink, to connect to HMC. You can download Plink from 
 https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

Plink.exe file must be placed in the following folder
../PowerHmcLparSettingsChange/exe

2) ssh connection and remote commands execution, must be enabled on HMC
https://www.ibm.com/support/pages/hmc-enhanced-view-enabling-sshremote-command-execution

3) Check and fill required vars (edit txt files)

## How it works?
1) Complete Initial Settings
2) Double click on PowerHmcLparSettingsChange.cmd, and the tool will execute the following tasks:
    * Verify that HMC is reachable
    * Verify that User and Password provided are correct
    * Check if Power Servers name you specified is managed by Hmc
    * Check if Lpar ID you specified is defined in the managed server
    * Check if Lpar profile you specified, is defined in the lpar ID
    * Check the Lpar status "in loop" waiting for "Not activated" State
    * Change the required parameter setting
    * Check if the parameter has been changed (if not, sends message!)
    * Power on lpar (in any case)
    * Check "in loop" the Lpar status waiting for "Activated" State
    * Sends all logs, in a txt file, for check/debug purpose

3) You can duplicate PowerHmcLparSettingsChange folder, as many time as you want, in order to execute the tool and manage as many time as lpars settings changes you want.

## Whats next?
I developed also PowerHmcLparSettingsCheck tool, in order to check the Lpar LPM settings with a simple "double click".
If you are interested, you can find at

https://github.com/SimoneGitHubUser/PowerHmcLparSettingsCheck

Let me know!



