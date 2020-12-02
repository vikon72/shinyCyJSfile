library(shiny)
library(openxlsx)
library(shinyCyJS)

ui = function(){
  fluidPage(
    ShinyCyJSOutput(outputId = 'cy',width = "100%",height = "900px"),
  )
}

server = function(input, output, session){
  node_data<-reactive({read.xlsx("node.xlsx")})
  edge_data<-reactive({read.xlsx("edge.xlsx")})

  node = reactive({
    data.frame(
    id = node_data()[,"name"],
    width = as.numeric(node_data()[,"size"]),
    height = node_data()[,"size"],
    shape = "ellipse",
    bgColor = node_data()[,"color"],
    bgFill = "solid",
    label = node_data()[,"name"],
    borderColor = "#FFFFFF",
    borderWidth=1,
    labelColor="#00000",
    fontSize = 10
    )
  })

  edge = reactive({
    data.frame(
    source = edge_data()[,1],
    target = edge_data()[,2],
    ####### error #######
    # width = 3,
    # width = as.numeric(edge_data()[,"edge_width"]),
    
    #####################
    lineStyle = edge_data()[,"type"],
    lineColor = edge_data()[,"edge_color"]
    )
  })

  nodes = reactive({buildElems(node(), type = 'Node')})
  edges = reactive({buildElems(edge(), type = 'Edge')})

  obj = reactive({shinyCyJS(c(nodes(), edges()),layout = list(name = "cola"),width ="100%",height="900px")})
  output$cy = renderShinyCyJS({obj()})
}

shinyApp(ui,server, options = list(launch.browser = TRUE, display.mode ='normal'))