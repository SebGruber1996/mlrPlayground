# should probabilites be used for classification?
output$prob_sel = renderUI({
  req(input$learner_1)
  req(req(input$tasktype) == "classif")
  # don't change value once learner changes
  value = if (is.null(isolate(input$prob))) FALSE else isolate(input$prob)

  fluidRow(
    column(6, custom_checkboxInput("prob", "Use probabilities", value = value))
  )
})


# calculate the prediction panel of learner 1 once resample predictions are
# calculated
output$learner_1_preds = renderUI({

  result = req(process$resample[["1"]])
  # transform measure df with 1 row to vector (and remove 1st element)
  perf = unlist(result$measures.test[-1])

  # consol information for debugging
  print("Rendering pred tab for learner 1...")

  table_measures = {
    len = length(perf)
    # indeces for split into 3 columns
    i1 = 1                  : ceiling(len/3)
    i2 = ceiling(len/3+1)   : ceiling(len*2/3)
    i3 = ceiling(len*2/3+1) : len
    # create 3 tables
    splitLayout(
      renderTable({
        data.frame(Measure = names(perf)[i1], Value = perf[i1])
      }),
      renderTable({
        data.frame(Measure = names(perf)[i2], Value = perf[i2])
      }),
      renderTable({
        data.frame(Measure = names(perf)[i3], Value = perf[i3])
      })
    )
  }

  # which panel should be open?
  open = {
    if (is.null(isolate(input$collapse_1)))
      "> Learner 1 predictions <"
    else isolate(input$collapse_1)
  }

  bsCollapse(
    id = "collapse_1",
    open = open,
    bsCollapsePanel(
      "> Learner 1 measures <",
      table_measures
    ),
    bsCollapsePanel(
      "> Learner 1 predictions <",
      process$getPredPlot(1),
      bsTooltip("predictionPlot_1", "Drag box to zoom. Double click to reset.", placement = "right")
    )
  )
})


# calculate the prediction panel of learner 2 once resample predictions are
# calculated
output$learner_2_preds = renderUI({

  result = req(process$resample[["2"]])
  # transform measure df with 1 row to vector (and remove 1st element)
  perf = unlist(result$measures.test[-1])

  # consol information for debugging
  print("Rendering pred tab for learner 2...")


  table_measures = {
    len = length(perf)
    # indeces for split into 3 columns
    i1 = 1                  : ceiling(len/3)
    i2 = ceiling(len/3+1)   : ceiling(len*2/3)
    i3 = ceiling(len*2/3+1) : len
    # create 3 tables
    splitLayout(
      renderTable({
        data.frame(Measure = names(perf)[i1], Value = perf[i1])
      }),
      renderTable({
        data.frame(Measure = names(perf)[i2], Value = perf[i2])
      }),
      renderTable({
        data.frame(Measure = names(perf)[i3], Value = perf[i3])
      })
    )
  }

  # which panel should be open?
  open = {
    if (is.null(isolate(input$collapse_2)))
      "> Learner 2 predictions <"
    else isolate(input$collapse_2)
  }

  bsCollapse(
    id = "collapse_2",
    open = open,
    bsCollapsePanel(
      "> Learner 2 measures <",
      table_measures
    ),
    bsCollapsePanel(
      "> Learner 2 predictions <",
      process$getPredPlot(2),
      bsTooltip("predictionPlot_2", "Drag box to zoom. Double click to reset.", placement = "right")
    )
  )
})
