<h1>
  <img src="https://raw.githubusercontent.com/alexisph/pvpaR/master/App/www/logo_small.png" alt="Photovoltaic Performance Analysis in R">
</h1>

[![GitHub issues](https://img.shields.io/github/issues/alexisph/pvpaR.svg?maxAge=2592000?style=flat)](https://github.com/alexisph/pvpaR/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](http://makeapullrequest.com)
[![license](https://img.shields.io/github/license/alexisph/pvpaR.svg?maxAge=2592000?style=flat)](https://github.com/alexisph/pvpaR/blob/master/LICENSE)

_**pvpaR** is a platform for the automatic identification and classification of faults and performance loss in Photovoltaic systems_

The paper describing the platform will be published in the 43rd IEEE Photovoltaic Specialists conference proceedings, under the title "Development of a Novel Web Application for Automatic Photovoltaic System Performance Analysis and Fault Identification."
A poster will be presented at the above conference on the 8th of June 2016, at 12:00 in Area 9, Exhibit Hall A1, Oregon Convention Center.


## Features

- Import [time-series](https://cran.r-project.org/web/views/TimeSeries.html) of PV system measurements and meteorological conditions
- Imported data can be in the form of flat files (e.g. csv, xls(x), txt etc.) or database tables (e.g. MySQL, PostgreSQL, Redis, SQLite, MongoDB, Cassandra etc.) or scraped from the [web](https://cran.r-project.org/web/views/WebTechnologies.html)
- User selectable date ranges
- Plot measurements and model results as [dynamic graphs](http://dygraphs.com/)
- Model the expected PV system performance from meteorological measurements
- Model and [transpose](https://cran.r-project.org/web/packages/solaR/index.html) the incident irradiance to the plane of array
- Model module temperature
- Compares model results with recorded measurements and checks for measurement errors
- Identifies outliers and abnormal performance losses
- Classifies the identified faults and shows the occurence of the identified fault


## Usage

Create a spec file describing the PV system. For an example see [specs.R](App/specs.R)

Run the `runShiny.R` script:

`$ R CMD BATCH ~/pvpaR/runShiny.R`

or, to run R in a separate process:

`$ R −e "shiny::runApp('~/pvpaR/App', launch.browser = TRUE)"`


## Bugs

Submit any bugs as [issues](https://github.com/alexisph/pvpaR/issues).


## Roadmap

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


## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) for instructions on contributing to this project and submitting clean code.

Special thanks go to all the people who contributed to this project. The list of current and past contributors can be found in [CONTRIBUTORS.md](CONTRIBUTORS.md).


## License

Copyright (c) 2014--2016 [Alexander Phinikarides](mailto:alexisph@gmail.com)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE
See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
