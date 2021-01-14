**WRF-STILT tutorial**<br> 

If you are reading this tutorial you are likely interested in running HYSPLIT-STILT with model output from the Weather Research and Forecast model (Skamarock et al. 2008). First, why *WRF-STILT*?

1) While there are a number of meteorological input files out there, many of these analyses have either limited domains and/or spatial resolution. Coarse spatial resolution can limit the ability for STILT to accurately trace air flow in areas with complex terrain and/or fine-scale meteorological circulations. WRF offers a way to downscale coarser-scale meteorological analyses to resolutions needed to resolve smaller-scale phenomena.
2) Many analyses just do not cover times you are interested. The High-Resolution Rapid Refresh model (HRRR) is a state of the art NWP model that has the grid spacing needed to resolve most mesoscale circulations. However, HRRR has only been operational since 2015. If you want to investigate something before that, you could be out of luck!
3) Model and model analyses have biases. There are just some meteorological phenomena that these analyses struggle with. For example, NWP models have a hard time getting snowpack correct. Across the Intermountain West, this snowpack can be really important driver for persistent cold-pool inversions in mountain-valley basins. Many times, snow depth is a quantity that can be better prescribed in a model like WRF, which may give the model a better chance at resolving persistent cold-pool inversions, which can ultimately impact local transport. This is just one of many examples why someone may want to use WRF over other model analyses.


