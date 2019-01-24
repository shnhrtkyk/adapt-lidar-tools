# Adapt-Lidar-Tools
PulseWaves format full waveform LiDAR data processing tools

## Introduction

The PulseWaves format is a new, open, vendor-neutral, LGPL-licensed and LAS-compatible data exchange format that is aimed at storing the entire digitized waveform instead of discrete returns(like the LAS format) in a fully geo-referenced manner. The PulseWaves format consists of two binary files: **pulse files(.pls)** that describe the emitted laser pulses via a georeferenced origin and **target point and waves files(.wvs)** that contain the actual samples of the outgoing and returning waveform shapes for the digitized sections of the emitted and received waveforms. 

This project aims at developing full waveform LiDAR processing tools based on the PulseWaves data exchange format 

## Installation

* Clone the repository to your local filesystem/ R2 account: `git clone https://github.com/BoiseState-AdaptLab/adapt-lidar-tools.git`
* After cloning the directory, 
  * If the installation is on the R2 compute cluster, you will need to load the following:
    * `module load gsl/gcc/2.4`
    * `module load gdal/intel/2.2.2`
  * If the installation is on your local filesystem, make sure you have the following installed: 
    * g++ (GCC 4.8.5)
    * GSL 2.4
    * GDAL 2.2.2
* Run the install script `./install.sh` to automatically download, update & build the dependencies, and make the executables.
  * For R2 users, if you had errors during the installation process you most likely have a module loaded that is causing a conflict. We recommend you remove all modules `module purge` and load only the ones required to make the executables.
* If the install script ran successfully, you can find the executables in either your choice of directory if you so chose during installation, or the `bin/` folder of the `adapt-lidar-tools` directory.

**Note:** After running the install script to make sure the dependencies are built, you can at any time regenerate the executables by running `make geotiff-driver` or `make pls-info`. To cleanup and remove all executables and object files , run `make clean`.

## Usage

**To generate GeoTIFFs representing the maximum elevation of the given pulse wave files:**

* `<path-to-installation-folder>/geotiff-driver -f <path-to-pls-file>` will generate the GeoTiff files in the same folder you run the above command from

**Note:** The pls and corresponding wvs files of the pulse wave set must be in the same folder. 

**To display the header information from the pulse wave file:**

* `<path-to-installation-folder>/pls-info <path-to-pls-file>`


## Credits
* [Ravi Shankar](http://coen.boisestate.edu/adaptlab/students/) [![](https://rvishnkr.github.io/images/ravi-email.png)](#)
* [Dr. Catherine Olschanowsky](https://coen.boisestate.edu/catherineolschan/)
* Nayani Ilangakoon
* [Dr. Nancy Glenn](https://bcal.boisestate.edu/people/staff/nancy-glenn/)

