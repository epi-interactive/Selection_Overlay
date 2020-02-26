
##################################
# Created by EPI-interactive
# 27 Feb 2020
# https://www.epi-interactive.com
##################################


EPISelectUI <- function(id, modalTitle, includeTitle, excludeTitle) {
  ns <- NS(id)

  modalDialog(
    ### layout###
    fluidRow(
      column(10, 
             h1(style = "padding: 0px 10px 10px 10px; margin-top: 0px;", modalTitle)
             ),
      column(2, style = "text-align: right;",
             actionButton(ns("closeBtn"), "Close")
             )
    ),
    hr(),
    fluidRow(
      class = "item-filter-row",
      # Included lakes list
      column(
        width = 5,
        h3(includeTitle),
        dataTableOutput(ns("included_items"))
      ),

      # Transfer options from included list to excluded list, and vice versa
      column(
        class = "item-filter-btn-col", width = 2,

        actionButton(class = "item-filter-btn", ns("exclude_btn"), "Exclude"),

        actionButton(class = "item-filter-btn",ns("exclude_all_btn"), "Exclude All"),
        br(),
        br(),
        br(),
        actionButton(class = "item-filter-btn",ns("include_btn"), "Include"),

        actionButton(class = "item-filter-btn",ns("include_all_btn"), "Include All")
      ),

      # Excluded lakes list
      column(
        width = 5,
        h3(excludeTitle),
        dataTableOutput(ns("excluded_items"))
      )
    ),

    # modal options
    size = "l", easyClose = TRUE, footer = NULL
  )
}


tableHTML <- function(data) {
  
  # EXAMPLE SPECIFIC CUSTOMISATION #
  displaydata <- select(as.data.frame(data), iso_a2, name_long, continent)
  names <- c("ISO Tag", "Name", "Continent")
  # END OF EXAMPLE SPECIFIC CUSTOMISATION #
  
  datatable(displaydata,
    escape = FALSE,
    rownames = F,
    colnames = names,
    options = list(
      paging = FALSE,
      bInfo = FALSE,
      searching = FALSE,
      ordering = TRUE,
      scrollX = TRUE,
      scrollY = "400px",
      columnDefs = list(
        list(
          targets = "_all",
          defaultContent = "-"
        )
      )
    )
  )
}
