* Setup base environment for GSHRE environment

** Set varabbrev off
set varabbrev off

* Find my home directory, depending on OS.
if ("`c(os)'" == "Windows") {
    local temp_drive : env HOMEDRIVE
    local temp_dir : env HOMEPATH
    global homedir "`temp_drive'`temp_dir'"
    macro drop _temp_drive _temp_dir`
}
else {
    if ("`c(os)'" == "MacOSX") | ("`c(os)'" == "Unix") {
        global homedir : env HOME
    }
    else {
        display "Unknown operating system:  `c(os)'"
        exit
    }
}

// for random assignment of PM
set seed 98034

**********************************
* Check for package dependencies *
**********************************
* This checks for packages that the user should install prior to running the project do files.

capture : which ereplace
if (_rc) {
    display as error in smcl `"Please install package {it:ereplace} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install ereplace":auto-install ereplace}"'
    exit 199
}


// Run personal setup file
do setup_`c(username)'
