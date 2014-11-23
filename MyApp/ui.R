library(shiny)
liax<-list(
  "Year Built" = "C.Year.Built",
  "Total Units" = "C.Total.Units",  
  "Expense per SqFt" = "C.Expense.per.SqFt",
  "Condo Market Value per SqFt" = 'C.Market.Value.per.SqFt',
  "Rental Gross Income per SqFt" ='R1.Gross.Income.per.SqFt'
)
li<-list(
  '(Monotone)' = 'Monotone',
  "Year Built" = "C.Year.Built",
  "Total Units" = "C.Total.Units",
  "Classification" = "C.Building.Classification",                    
  "Neighborhood" = "C.Neighborhood",
  "Expense per SqFt" = "C.Expense.per.SqFt",
  "Condo Market Value per SqFt" = 'C.Market.Value.per.SqFt',
  "Rental Gross Income per SqFt" ='R1.Gross.Income.per.SqFt'
)
clsli<-list('R2','R4','R9','RR')

#neiu<-unique(d$C.Neighborhood)
#paste(neiu[order(neiu)],collapse='\',\'')
nei<-list('ALPHABET CITY','CHELSEA','CHINATOWN','CLINTON','EAST VILLAGE','FASHION','FINANCIAL','FLATIRON','GR VILLAGE','GRAMERCY','HARLEM','LITTLE ITALY','LOWER EAST','MANHATTAN VALLEY','MIDTOWN','MURRAY HILL','OTHER','SOHO','TRIBECA','UPPER EAST','WASH HTS')
shinyUI(pageWithSidebar(
  headerPanel("Realestate Market Analysis in Manhattan"),
  sidebarPanel(    
    h4("Filter"),
    #h3('Input'),
    #sliderInput("rnum","Number of random values",value=100,min=5,max=300,step=10),    
    sliderInput("price", "Price:",min = 500000, max = 50000000, value = c(500000,50000000)),
    sliderInput("year_built", "Year Built:",min = 1900, max = 2011, value = c(1900,2011)),
    checkboxGroupInput("classification", label = "Classification", 
                       choices = clsli,
                       selected = clsli),    
    h4("Settings"),
    selectInput("color", 
                label ="Color", 
                choices = li, 
                selected =  "C.Year.Built"),    
    selectInput("x", 
                label ="X-axis", 
                choices = liax, 
                selected =  'C.Market.Value.per.SqFt'),
    selectInput("y", 
                label ="Y-axis", 
                choices = liax, 
                selected =  'R1.Gross.Income.per.SqFt'),
    p('.'),
    p('.'),
    p('.'),
    p('.'),
    p('.'),
    p('.')
  ),  
  mainPanel(
    p('This is an interactive dashboard for realestate developers or investors in Manhattan who try to purchase condo, and making profit by renting them out to tenants. As investor, you should focus on properties with higher ROI (Return of Investment): Higher Rental Income (Y-axis) to manage and Lower Market Value (X-axis) to buy. From the left menu, you can filter by Year Built, Category and so on. To change colorization schema and x-y coordinates, please use dropdowns in the Settings section.'),
    plotOutput('resplot'),         # image rendering
    verbatimTextOutput('sumtxt'), # with <pre></pre> tags    
    checkboxGroupInput("nei", label = "Neighborhood Selection", 
                       choices = nei,
                       selected = nei, inline=TRUE)
  )
))