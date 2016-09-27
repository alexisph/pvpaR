<h1>
  <img src="https://raw.githubusercontent.com/alexisph/pvpaR/master/App/www/logo_small.png" alt="Photovoltaic Performance Analysis in R">
</h1>

[![GitHub issues](https://img.shields.io/github/issues/alexisph/pvpaR.svg?maxAge=2592000?style=flat)](https://github.com/alexisph/pvpaR/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](http://makeapullrequest.com)
[![license](https://img.shields.io/github/license/alexisph/pvpaR.svg?maxAge=2592000?style=flat)](https://github.com/alexisph/pvpaR/blob/master/LICENSE)

_**pvpaR** is a platform for the automatic identification and classification of faults and performance loss in Photovoltaic systems_

The paper describing the platform was published in the 43rd IEEE Photovoltaic Specialists conference proceedings, under the title "Development of a Novel Web Application for Automatic Photovoltaic System Performance Analysis and Fault Identification."
A poster was presented at the above conference on the 8th of June 2016, at 12:00 in Area 9, Exhibit Hall A1, Oregon Convention Center.


## Features

- Import [time-series](https://cran.r-project.org/web/views/TimeSeries.html) of PV system and meteorological measurements. Imported data can be in the form of flat files (e.g. csv, xls(x), txt etc.) or database tables (e.g. MySQL, PostgreSQL, Redis, SQLite, MongoDB, Cassandra etc.) or scraped from the [web](https://cran.r-project.org/web/views/WebTechnologies.html)
- User selectable date ranges applied to the whole platform
- Plot measurements and model results in [interactive graphs](http://dygraphs.com/)
- Model the expected PV system performance from meteorological measurements and past PV system performance
- Model and [transpose](https://cran.r-project.org/web/packages/solaR/index.html) the incident irradiance to the plane of array
- Model module temperature
- Compare model results with actual measurements and indicate measurement errors
- Identify faults and sub-optimal performance
- Classify identified faults


## Usage

Create a specification file describing the PV system. For an example see [specs.R](App/specs.R)

Run the `runShiny.R` script:

`$ R CMD BATCH ~/pvpaR/runShiny.R`

or, to run R in a separate process:

`$ R −e "shiny::runApp('~/pvpaR/App', launch.browser = TRUE)"`


## Bugs

Submit any bugs as [issues](https://github.com/alexisph/pvpaR/issues).


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

