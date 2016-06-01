# Copyright (c) 2014--2016 Alexander Phinikarides <alexisph@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Load the required packages, variables and data --------------------------

source("packages.R")
source("specs.R")


# Header and theme --------------------------------------------------------

shinyUI(
  fluidPage(
    title = "pvpaR - Photovoltaic Performance Analysis in R",
    theme = "bootstrap_lumen.css",

    titlePanel(""),


    # Sidebar -----------------------------------------------------------------

    sidebarLayout(
      sidebarPanel(
        img(src = "logo.png", class = "img-responsive", alt = "Photovoltaic Performance Analysis in R"),
        tabsetPanel(

          tabPanel("Settings",

                   dateRangeInput("dateRange",
                                  label = h4(icon("calendar"), "Date range for analysis"),
                                  start = index(tail(datIn, 1)) - 432000, # 432000sec = 5days
                                  end = index(tail(datIn, 1)) - 1,
                                  min = index(head(datIn, 1)),
                                  max = index(tail(datIn, 1)),
                                  format = "yyyy-mm-dd"
                   ),
                   hr(),

                   sliderInput("panel_soiling", label = h4(icon("adjust"), "PV panel soiling (1=clean, 4=dirty)"),
                               min = 1, max = 4, value = 2),
                   hr(),

                   h4(icon("location-arrow"), "System location"),
                   tableOutput("location"),
                   htmlOutput("system_map"),
                   hr(),

                   h4(icon("info-circle"), "System specifications"),
                   tableOutput("specs")
          ),

          tabPanel("About",
                   p(""),
                   p("pvpaR is a platform for the automatic identification and classification of faults and performance loss in Photovoltaic systems."),
                   hr(),

                   h4("Nomenclature"),
                   p(strong("POA"), ": Plane Of Array"),
                   p(strong("vdc"), ": DC Voltage [V]"),
                   p(strong("idc"), ": DC Current [A]"),
                   p(strong("pdc"), ": DC Power [W]"),
                   p(strong("pac"), ": AC Power [W]"),
                   p(strong("tmod"), ": Module Temperature [°C]"),
                   p(strong("tamb"), ": Ambient Temperature [°C]"),
                   p(strong("ghi"), ": Global Horizontal Irradiance [Wm-2]"),
                   p(strong("gpoa"), ": Global Irradiance from a Pyranometer on the POA [Wm-2]"),
                   p(strong("gref"), ": Global Irradiance from a Reference Cell on the POA [Wm-2]"),
                   p(strong("uw"), ": Wind Speed [m/s] "),
                   p(strong("aw"), ": Wind Direction [°]"),
                   p(strong("hrel"), ": Relative Humidity [%]"),
                   hr()
          ),

          tabPanel("Disclaimer",
                   p(""),
                   p("This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version."),
                   p("This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details."),
                   p("You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>."),
                   p("The source code is available on", a(href = "https://github.com/alexisph/pvpaR", "GitHub")),
                   hr(),

                   tags$small(p("Copyright", icon("copyright"), "2014-2016", a(href = "mailto:alexisph@gmail.com", "Alexander Phinikarides")))
          )
        )
      ),


      # Main panel --------------------------------------------------------------

      mainPanel(
        # orange colour: #F7931E, green colour: #7F911B
        tabsetPanel(

          tabPanel("Measurements", icon = icon("area-chart"),
                   h4("Power Production"), dygraphOutput("p_range"),
                   hr(),
                   h4("Irradiance"), dygraphOutput("g_range"),
                   hr(),
                   h4("Temperature"), dygraphOutput("t_range"),
                   hr(),
                   h4("Inverter Efficiency"), plotOutput("ac_dc_range"),
                   hr()
          ),

          tabPanel("Missing data", icon = icon("circle-o"),
                   h4("Missing DC Voltage:"), p(""),
                   tableOutput("missing_vdc"), p(""),
                   hr(),

                   h4("Missing DC Current:"), p(""),
                   tableOutput("missing_idc"), p(""),
                   hr(),

                   h4("Missing DC Power:"), p(""),
                   tableOutput("missing_pdc"), p(""),
                   hr(),

                   h4("Missing AC Power:"), p(""),
                   tableOutput("missing_pac"), p(""),
                   hr(),

                   h4("Missing Module Temperature:"), p(""),
                   tableOutput("missing_tmod"), p(""),
                   hr(),

                   h4("Missing Global Irradiance on the POA:"), p(""),
                   tableOutput("missing_gpoa"), p(""),
                   hr(),

                   h4("Missing Global Irradiance from a Reference Cell on the POA:"), p(""),
                   tableOutput("missing_gref"), p(""),
                   hr(),

                   h4("Missing Global Horizontal Irradiance:"), p(""),
                   tableOutput("missing_ghi"),
                   hr(),

                   h4("Missing Wind Speed:"), p(""),
                   tableOutput("missing_uw"), p(""),
                   hr(),

                   h4("Missing Wind Direction:"), p(""),
                   tableOutput("missing_aw"), p(""),
                   hr(),

                   h4("Missing Ambient Temperature:"), p(""),
                   tableOutput("missing_tamb"), p(""),
                   hr(),

                   h4("Missing Relative Humidity:"), p(""),
                   tableOutput("missing_hrel"), p(""),
                   hr()
          ),

          tabPanel("Model results", icon = icon("cloud"),
                   h4("Transposed Irradiance on the POA"),
                   dygraphOutput("gpoa_model_range"),
                   hr(),

                   h4("Transposed vs Measured Global Irradiance on the POA"),
                   plotOutput("gpoa_comp_range"),
                   hr(),

                   h4("Diffuse Components of the Transposed GHI on the POA"),
                   dygraphOutput("diffuse_range"),
                   hr()
          ),

          tabPanel("Outlier detection", icon = icon("warning"),
                   h4("Outliers on measured PV performance"),
                   plotOutput("pdc_outliers_range"),
                   p(""),
                   plotOutput("vdc_outliers_range"),
                   p(""),
                   plotOutput("irrad_outliers_range"),
                   p(""),

                   h4("Capture Losses Error"),
                   dygraphOutput("elc_range"),
                   p(""),
                   dygraphOutput("ei_ev_range"),
                   hr()
          ),

          tabPanel("Fault classification", icon = icon("object-group"),
                   h4("Shading / Soiling of the PV array"),
                   tableOutput("shading_array"), p(""),
                   hr(),

                   h4("Shading / Soiling of the irradiance sensor"),
                   tableOutput("shading_sensor"), p(""),
                   hr(),

                   h4("DC Power not as expected"),
                   tableOutput("fault_pdc"), p(""),
                   hr(),

                   h4("DC current not as expected"),
                   tableOutput("fault_idc"), p(""),
                   hr(),

                   h4("AC power not as expected"),
                   tableOutput("fault_pac"), p(""),
                   hr(),

                   h4("Partial shading of the PV array / Blocking diode failure"),
                   tableOutput("ei_fault2"), p(""),
                   hr(),

                   h4("Short circuit of one or more modules / bypass diodes or PV array at open circuit"),
                   tableOutput("ev_fault"), p(""),
                   hr(),

                   h4("Disconnection of one or more modules"),
                   tableOutput("disconnection"), p(""),
                   hr()
          )
        ),


        # Footer ------------------------------------------------------------------

        tags$small(p("Copyright", icon("copyright"), "2014-2016", a(href = "mailto:alexisph@gmail.com", "Alexander Phinikarides")))
      )
    )
  )
)
