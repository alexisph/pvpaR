# Roadmap

Copyright (c) 2014--2016 [Alexander Phinikarides](mailto:alexisph@gmail.com)

The following features are planned for development:

- KPIs
    1. Performance Ratio
    2. Exported energy (and all-time high)
    3. System uptime and downtime
    4. Expected energy yield (e.g. progress bar)
    5. ~~Inverter efficiency~~
- Granularity
    1. Dataset minimum
    2. 15 min
    3. Hourly
    4. Daily
    5. Monthly
    6. Yearly
- ~~Modifiable settings (e.g. soiling)~~
- RMSE, MAE and MBE for V, I, G and P predictions
- User selectable sources of irradiance:
    - Locally measured GHI transposed onto the plane of array (POA)
    - Locally measured Gpoa
    - PVGIS or NASA hourly on the POA
    - Clear-sky model
- User selectable sources of temperature:
    - Locally measured Tmod
    - Locally measured Tamb and u_w used to predict Tmod
    - Tamb from NASA or PVGIS
- Estimation of seasonal and trend components
- Separate early degradation from long-term degradation trend
- User selectable filters such as:
    - High Gi
    - Low Gi
    - Low AOI
    - Low Gi volatility
    - Low u_w value and volatility (for temperature stability)
    - Irradiance around the maximum unclipped power
- Cache results, e.g. [archivist](https://cran.r-project.org/web/packages/archivist/index.html)

