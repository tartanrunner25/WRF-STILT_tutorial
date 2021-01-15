# WRF-STILT tutorial
*Written by Derek V. Mallia, Ben Fasoli, and Chris Loughner*<br>
*Version: January 14th, 2021*

<img src='./images/WRF-STILT_run.png' width=500px align='right' style='padding-left:30px'>

**PREFACE:**<br>
If you are reading this tutorial you are likely interested in running HYSPLIT-STILT with model output from the Weather Research and Forecast model (WRF; Skamarock et al. 2008). First, why *WRF-STILT*?

1) While there are a number of meteorological input files out there, many of these analyses have either limited domains and/or spatial resolution. Coarse spatial resolution can limit the ability for STILT to accurately trace air flow in areas with complex terrain and/or fine-scale meteorological circulations. WRF offers a way to downscale coarser-scale meteorological analyses to resolutions needed to resolve smaller-scale phenomena.
2) Many analyses just do not cover times you are interested. The High-Resolution Rapid Refresh model (HRRR) is a state of the art NWP model that has the grid spacing needed to resolve most mesoscale circulations. However, HRRR has only been operational since 2015. If you want to investigate something before that, you could be out of luck!
3) Model and model analyses have biases. There are just some meteorological phenomena that these analyses struggle with. For example, NWP models have a hard time getting snowpack correct. Across the Intermountain West, this snowpack can be really important driver for persistent cold-pool inversions in mountain-valley basins. Many times, snow depth is a quantity that can be better prescribed in a model like WRF, which may give the model a better chance at resolving persistent cold-pool inversions, which can ultimately impact local transport. This is just one of many examples why someone may want to use WRF over other model analyses.

*However, there are some cavaets...*
1) WRF is not easy to use. If you have a colleague that can run WRF for you, lucky you! In most cases, this is not an option. This tutorial is not meant to show you how to become a proficient WRF modeler as this can take months to even years of practice. The most this tutorial will do is show you how to convert output files already generated from WRF. More information on WRF can be found [here!](https://www2.mmm.ucar.edu/wrf/users/)
2) Always look at your model output with a careful eye. Just because WRF ran, does not mean it produced something realistic (most time it does, thankfully). Always be sure to evaluate your model data with observations!
3) WRF is awesome, I've built my career around WRF. But running WRF may not make sense for every application. Be sure check out some of the other fantastic meteorological analyses out there and first see if they make sense for your application/research! It may not be necessary to re-invent the wheel!

Before we conclude, the authors would like to acknowledge John C. Lin and Thomas Nehrkorn for their support on WRF-STILT related activities.
With that said, let's get you up and running with WRF-STILT. 


# Before running WRF

Results in Nehrkorn et al. (2011) showed that mass conversation within STILT can be drastically improved by using time-average winds instead of the instantanous winds that are often produced for each output frame. As a result, we encourage WRF-STILT users to modify the WRF Registry so that time-average winds are added to the WRF output file. 

To activate the history output `hr` for the variables needed by the ARL converter, users should change the following lines within `./Registry/Registry.EM_COMMON`: 

<img src='./images/registry.png' width=900px align='center' style='padding-left:50px'>


The following lines should also be added added to the wrf namelist `namelist.input` under the &dynamics section:

`do_avgflx_em                        = 1, 1, 1, 1, 1, 1, 1, 1, 1,`<br>
`do_avgflx_cugd                      = 1, 1, 1, 1, 1, 1, 1, 1, 1,`<br>

Finally, note that any time a change is made to the WRF Registry, WRF will need to be recompiled.
<br>
<br>

# Compiling the WRF ARL converter 

If you are installing STILT v2.0 using pre-compiled libraries (recommended), no additional action is needed to set up the `arw2arl` executable, which should be located in STILT v2.0's `./exe` directory. If you decide to compile your HYSPLIT-STILT code from source, you will need to make additional changes to the `Makefile.inc` by linking netCDF environment paths to the appropriate libraries:

For example:

> NETINC= -I/uufs/chpc.utah.edu/common/home/lin-group12/software/local/include<br>
> NETLIBS= -L/uufs/chpc.utah.edu/common/home/lin-group12/software/local/lib -lnetcdff	# for netCDF4<br>

Once the appropriate paths have been set for `NETINC` and `NETLIBS`, run the following commands to compile the arw2arl code:

> (cd data2arl/arw2arl && make)

Once the compilation finishes, check the `exec` directory to ensure that the arw2arl executable has been created. 



<br>
<br>

# Running the WRF ARL converter 

The next step of this guide is to show you how to run the `arw2arl` code on WRF output files (which are hopefully in in netcdf format). In order to run the ARL converter, you will need 3 files:
1) Your WRF output file(s)
2) The ARL converter configuration file `WRFDATA.CFG`
3) And of course, the ARL executable `arw2arl`

The `WRFDATA.CFG` file is responsible for configuring the ARL converter to run with your WRF input files. Most of the times, this can be left as the default, which has been provided below. However, there are some instances were you may need to make changes to this file, such as using instantaneous winds, TKE variables, and so on. More documentation on how to setup the configuration can be found here: https://github.com/tartanrunner25/WRF-STILT_tutorial/blob/main/Note-arw2arl.pdf

For now, stick with the default `WRFDATA.CFG` file, which has been provided within the repository (top level). This file should be in the same directory that you are running the code from.

In order to run the executable with the file of interest you simply need to execute the `arw2arl` code, followed by the input WRF filename and path `-i`, the name of the file that will be created `-o`, and a flag that specifies the configuration file type that we will be using (`-c1`, `-c2`, or `-c3`). For time-average winds, we use `-c2`. The line that we execute in our terminal line should look something like this:

> ./arw2arl -i$WRF_FILE_PATH_HERE/WRF_FILE_NAME_HERE -c2

<br><br>
Note that in this example, we did not specify an output name, thus, the default filename was used `WRFDATA.ARL`. 

For cases were you are converting multiple WRF files, feel free to use the shell script provided within this repository `runarw.sh` and edit it accordingly. 

When running the ARL converter code, you should hopefully see the following lines being printed to your terminal screen:

> Using an existing decoding configuration: WRFDATA.CFG<br>
> Using an existing encoding configuration: ARLDATA.CFG<br>
>  NOTICE pakset:<br>
>  Number of index records =            1<br>
>  Number of records /time =          594<br>
>  NOTICE pakini: start initialization rec =            1<br>
>  NOTICE pakini:   end initialization rec =          594<br>
> Initialized accumulated precip from file: WRFRAIN.BIN<br>
> Completed:           15           9          11          18           0<br>

❗ The numbers printed above will depend on the domain size and date of your WRF simulations ❗

👍 One final tip! If you are using time-averaged winds, not that the first few frames of your WRF simulation *MAY NOT* have these variables available since these are generally computed as hourly "averages". So be sure to account for this when running your STILT simulations later on. Personally, I usually just toss out the first 3 hours of any WRF simulation since the model needs time to "spin up" mesoscale circulations!

<br>
<br>

# Running HYSPLIT-STILT with WRF ARL files

:warning: If you are using HYSPLIT-SILT v2020-05-24 (version 5), there may be compatibility issues with ARL converted WRF files. :warning:
<br>
Hopefully, everything ran smoothly and that you have some cool WRF ARL files to play with! At this point, you can treat your newly created WRF ARL files as any other ARL file that you would use with HYSPLIT-STILT. 
<br>
<br>

# Tutorial

Listed below is a tutorial for running WRF-STILT. In this tutorial sample WRF files have been provided for your convenience. These files can be downloaded from the following link: http://home.chpc.utah.edu/~u0703457/people_share/ARL_converter/WRF_tutorial_files/

In addition, download the following script `runarw_tutorial.sh` (provided in the top directory) for converting multiple WRF netCDF files.
<br><br>

**Step 1)** Downloaded the WRF files to your working directory, preferably to the same directory as your `arw2arl` executable. Edit the `runarw_tutorial.sh` script accordingly. This includes setting the correct file path locations.
<br><br>
**Step 2)** Run the shell script: `./runarw_tutorial.sh`. Be sure that `WRFDATA.CFG` is located in in the same directory as your script. 
<br><br>
**Step 3)** After you have successfully converted the WRF files provided above, edit the `run_stilt.r` accordingly. Note that the WRF files provided cover times between `2015-09-05_12:00:00` and `wrfout_d01_2015-09-06_03:00:00`. You will also need to change the names for `met_path` and `met_file_format`. Since this WRF simulation is centered over Salt Lake City, Utah; be sure that the correct receptor location and domain size is selected. The lines lists that lines that you may want to adjust and how.

> #User inputs ------------------------------------------------------------------<br>
> project <- 'NAME_OF_YOUR_PROJECT'<br>
> stilt_wd <- file.path('YOUR/PATH/SHOULD/GO/HERE', project)<br>
> output_wd <- file.path(stilt_wd, 'out')<br>
> lib.loc <- .libPaths()[1]<br>
>
> #Simulation timing, yyyy-mm-dd HH:MM:SS (UTC)<br>
> t_start <- '2015-09-06 00:00:00'<br>
> t_end   <- '2015-09-06 03:00:00'<br>
> run_times <- seq(from = as.POSIXct(t_start, tz = 'UTC'),<br>
>                  to   = as.POSIXct(t_end, tz = 'UTC'),<br>
>                  by   = 'hour')<br>
> 
> #Receptor location(s)<br>
> lati <- 40.740<br>
> long <- -111.860<br>
> zagl <- 5<br>
>
> #Footprint grid settings, must set at least xmn, xmx, ymn, ymx below<br>
> hnf_plume <- T<br>
> projection <- '+proj=longlat'<br>
> smooth_factor <- 1<br>
> time_integrate <- F<br>
> xmn <- -114.0<br>
> xmx <- -110.99<br>
> ymn <- 39.0<br>
> ymx <- 42.0<br>
> xres <- 0.01<br>
> yres <- xres<br><br>
>
> #Meteorological data input<br>
> met_path   <- '/uufs/chpc.utah.edu/common/home/u0703457/links/convert_arw2arl'<br>
> met_file_format <- 'wrfout_tutorial.arl'<br>
> met_subgrid_buffer <- 0.1<br>
> met_subgrid_enable <- F<br>
> met_subgrid_levels <- NA<br>
> n_met_min          <- 1<br>
>
> #Model control
> n_hours    <- -24
> numpar     <- 100
> rm_dat     <- T
> run_foot   <- T
> run_trajec <- T
> timeout    <- 3600
> varsiwant  <- c('time', 'indx', 'long', 'lati', 'zagl', 'foot', 'mlht', 'dens',
                'samt', 'sigw', 'tlgr','dmas')

<br><br>
**Step 4)** Once you are done editing the `run_stilt.r` script, be sure to save it. Then, run the script from your terminal `Rscript run_stilt.r`
<br><br>
**Step 5)** If the run was a success, STILT trajectory and footprint files should be located in the out directory `./out`
<br><br>


# References

Mallia, D. V., L. Mitchell, L. Kunik, B. Fasoli, R. Bares, D. Mendoza, K. Gurney, and J. C. Lin:], 2020:
Constraining urban CO2 emissions using mobile observations derived from a novel light-rail public transit platform. Environ. Sci. & Technol., 54, 24, 15613–15621.

Nehrkorn, T., J. Eluszkiewicz, S. C. Wofsy, J. C. Lin, C. Gerbig, M. Longo, and S. Freitas, 2010: Coupled weather research and forecasting - stochastic time-inverted lagrangian transport (WRF-STILT) model. Meteor. Atmos. Phys., 107 (1), 51-64, doi:10.1007/s00703-010-0068-x.

Skamarock, W. C., J. B. Klemp, J. Dudhia, D. O. Gill, D. Barker, M. G. Duda, J. G. Powers, 2008: A Description of the Advanced Research WRF Version 3 (No. NCAR/TN-475+STR). University Corporation for Atmospheric Research. doi:10.5065/D68S4MVH

