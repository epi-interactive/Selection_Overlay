
##################################
# Created by EPI-interactive
# 27 Feb 2020
# https://www.epi-interactive.com
##################################


EPISelect <- function(input, output, session, data) {
  output$included_items <- renderDT(tableHTML(data$inc))
  output$excluded_items <- renderDT(tableHTML(data$exc))

  ### PREVENT BUTTON USE WITHOUT SELECTION
  observeEvent(
    {
      input$included_items_rows_selected |
        input$excluded_items_rows_selected |
        input$exclude_btn |
        input$include_btn |
        input$exclude_all_btn |
        input$include_all_btn
    },
    {

      # Check if exclusion selection is empty. If it is, disable exclusion button

      if (is.null(input$included_items_rows_selected)) {
        disable("exclude_btn")
      }
      else {
        enable("exclude_btn")
      }

      # Check if inclusion selection is empty. If it is, disable inclusion button

      if (is.null(input$excluded_items_rows_selected)) {
        disable("include_btn")
      }
      else {
        enable("include_btn")
      }

      # Check if included df is empty. If it is, disable exclude all button

      if (nrow(data$inc) == 0) {
        disable("exclude_all_btn")
      }
      else {
        enable("exclude_all_btn")
      }

      # Check if excluded df is empty. If it is, disable include all button

      if (nrow(data$exc) == 0) {
        disable("include_all_btn")
      }
      else {
        enable("include_all_btn")
      }
    }
  )


  ### BUTTON EVENTS

  observeEvent(input$exclude_btn, {
    if (is.null(input$included_items_rows_selected)) {
      return()
    }
    data$exc <- rbind(data$exc, data$inc[input$included_items_rows_selected, ])
    data$inc <- data$inc[-input$included_items_rows_selected, ]
  })


  observeEvent(input$include_btn, {
    if (is.null(input$excluded_items_rows_selected)) {
      return()
    }

    data$inc <- rbind(data$inc, data$exc[input$excluded_items_rows_selected, ])
    data$exc <- data$exc[-input$excluded_items_rows_selected, ]
  })


  observeEvent(input$exclude_all_btn, {
    data$exc <- rbind(data$exc, data$inc)
    data$inc <- data$inc[0, ]
  })


  observeEvent(input$include_all_btn, {
    data$inc <- rbind(data$inc, data$exc)
    data$exc <- data$exc[0, ]
  })
  
  observeEvent(input$closeBtn, {
    removeModal()
  })
}
