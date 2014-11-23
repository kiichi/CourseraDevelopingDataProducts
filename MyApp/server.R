library(shiny)
library(ggplot2)

# To Deploy
# setwd("/Users/kiichi/work/r/class/CourseraDevelopingDataProducts")
# shinyapps::deployApp('MyApp')

#----------------------------------------------------------------------------------
# Load Data
# Reference: 
#   https://data.cityofnewyork.us/Housing-Development/DOF-Condominium-Comparable-Rental-Income-Manhattan/dvzp-h4k9
d<-read.csv("rental2.csv")

#----------------------------------------------------------------------------------
#Data Cleanup and Conversion
names(d)<-gsub('\\.\\.','.',gsub('MANHATTAN.CONDOMINIUMS.COMPARABLE.PROPERTIES','C',gsub('.â..','',gsub('COMPARABLE.RENTAL.â...','R',names(d)))))
d<-d[!is.na(d$C.Market.Value.per.SqFt)
     &!is.na(d$R1.Gross.Income.per.SqFt)
     &!is.na(d$C.Year.Built)
     &d$C.Year.Built>1900
     &d$C.Full.Market.Value<50000000,]
d$C.Neighborhood<-gsub('WASHINGTON HEIGHTS.*','WASH HTS',gsub('GREENWICH VILLAGE-.*','GR VILLAGE',gsub(' SIDE','',d$C.Neighborhood)))
d$C.Neighborhood<-gsub('GR VILLAGE-.*','GR VILLAGE',d$C.Neighborhood)
d$C.Neighborhood<-gsub('WASH HTS .*','WASH HTS',d$C.Neighborhood)
d$C.Neighborhood<-gsub('HARLEM-.*','HARLEM',d$C.Neighborhood)
d$C.Neighborhood<-gsub('UPPER EAST .*','UPPER EAST',d$C.Neighborhood)
d$C.Neighborhood<-gsub('UPPER WEST .*','UPPER WEST',d$C.Neighborhood)
d$C.Neighborhood<-gsub('MIDTOWN .*','MIDTOWN',d$C.Neighborhood)
d$C.Neighborhood<-gsub('CIVIC CENTER','OTHER',d$C.Neighborhood)
d$C.Neighborhood<-gsub('SOUTHBRIDGE','OTHER',d$C.Neighborhood)
d$C.Neighborhood<-gsub('JAVITS CENTER','OTHER',d$C.Neighborhood)
d$C.Neighborhood<-gsub('KIPS BAY','OTHER',d$C.Neighborhood)
d$C.Neighborhood<-gsub('INWOOD','OTHER',d$C.Neighborhood)
d$C.Building.Classification<-gsub('-CONDOMINIUM','',d$C.Building.Classification)
clabel<-function(str){
  gsub('\\.',' ',gsub('R1\\.','Rental ',gsub('C\\.','Condo ',str)))
}
d$Monotone<-0 #create static value column for default color

#----------------------------------------------------------------------------------
shinyServer(
  function(input, output) {        
    #output$echotxt <- renderText({as.numeric(input$rnum)})    
    output$resplot<-renderPlot({      
      xl<-xlim(min(d[,c(input$x)]), max(d[,c(input$x)]))
      yl<-ylim(min(d[,c(input$y)]), max(d[,c(input$y)]))
      yb_select<-d$C.Year.Built>=input$year_built[1]&d$C.Year.Built<=input$year_built[2]
      p_select<-d$C.Full.Market.Value>=input$price[1]&d$C.Full.Market.Value<=input$price[2]
      cls_select<-d$C.Building.Classification %in% input$classification
      nei_select<-d$C.Neighborhood %in% input$nei
      d<-d[yb_select&p_select&cls_select&nei_select,]
      fit<-lm(d[,input$y]~d[,input$x])
      co<-coef(fit)
      output$sumtxt<-renderPrint(sprintf("Linear Model Fit: Intercept=%.2f, Slope=%.2f",co[1],co[2]))
      #g<-qplot(C.Market.Value.per.SqFt,R1.Gross.Income.per.SqFt,data=d)
      #g<-qplot(aes_string(x='C.Market.Value.per.SqFt',y='R1.Gross.Income.per.SqFt',colour='C.Building.Classification'),data=d)
      g<-ggplot(data=d, aes_string(x=input$x,y=input$y,color=input$color))
      g<-g+geom_point(aes(size = 16,alpha=0.8))
      g<-g+xlab(clabel(input$x))
      g<-g+ylab(clabel(input$y))
      g<-g+xl
      g<-g+yl
      if (input$color=="C.Neighborhood"){
        g<-g+guides(col=guide_legend(ncol=2))
      }      
      if (input$color!="C.Building.Classification" && input$color!="C.Neighborhood"){
        g<-g+geom_smooth(method="lm")  
      }
      g
    })   
  }  
)