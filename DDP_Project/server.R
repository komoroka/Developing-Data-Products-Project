
library(shiny)
library(quantmod)
library(tidyquant)
library(ggplot2)
library(timeSeries)
library(dplyr)

symbol <- c('ATVI','ADBE','AMD', 'ALGN',
            'ALXN', 'AMZN','AMGN', 'AAL',
            'ADI', 'AAPL','AMAT', 'ASML', 'ADSK', 'ADP', 'AVGO', 'BIDU',
            'BIIB', 'BMRN', 'CDNS', 'CERN', 'CHKP', 'CHTR',
            'TCOM', 'CTAS', 'CSCO', 'CTXS', 'CMCSA', 'COST', 'CSX', 'CTSH',
            'DLTR', 'EA', 'EBAY', 'EXC', 'EXPE', 'FAST', 'FB', 'FISV',
            'GILD', 'GOOG', 'GOOGL', 'HAS', 'HSIC', 'ILMN', 'INCY', 'INTC',
            'INTU', 'ISRG', 'IDXX', 'JBHT', 'JD', 'KLAC', 'KHC', 'LRCX',
            'LBTYA', 'LBTYK', 'LULU', 'MELI', 'MAR', 'MCHP', 'MDLZ', 'MNST',
            'MSFT', 'MU', 'MXIM', 'MYL', 'NTAP', 'NFLX', 'NTES', 'NVDA',
            'NXPI', 'ORLY', 'PAYX', 'PCAR', 'BKNG', 'PYPL', 'PEP', 'QCOM',
            'REGN', 'ROST', 'SIRI', 'SWKS', 'SBUX', 'NLOK', 'SNPS', 'TTWO',
            'TSLA', 'TXN', 'TMUS','ULTA', 'UAL', 'VRSN', 'VRSK', 'VRTX',
            'WBA', 'WDC', 'WDAY', 'WYNN', 'XEL', 'XLNX')

companies <- c('Activision Blizzard Inc',	'Adobe Inc.',	'Advanced Micro Devices Inc',	
               'Align Technology Inc',	'Alexion Pharmaceuticals Inc',	
               'Amazon.com Inc',	'Amgen Inc',	'American Airlines Group Inc',	
               'Analog Devices Inc',	'Apple Inc',	'Applied Materials Inc',	
               'ASML Holding NV',	'Autodesk Inc',	'Automatic Data Processing Inc',	
               'Broadcom Inc',	'Baidu Inc',	'Biogen Inc',	'Biomarin Pharmaceutical Inc',	'Cadence Design Systems Inc',	'Cerner Corp',
               'Check Point Software Technologies Ltd',	'Charter Communications Inc',	
               'Trip.com Group Ltd',	'Cintas Corp',	'Cisco Systems Inc',	'Citrix Systems Inc',	
               'Comcast Corp',	'Costco Wholesale Corp',	'CSX Corp',	
               'Cognizant Technology Solutions Corp',	'Dollar Tree Inc',	'Electronic Arts',	
               'eBay Inc',	'Exelon Corp',	'Expedia Group Inc',	'Fastenal Co',	'Facebook',	
               'Fiserv Inc',	'Gilead Sciences Inc',	'Alphabet Class C',
               'Alphabet Class A',	'Hasbro Inc',	'Henry Schein Inc',	'Illumina Inc',	
               'Incyte Corp',	'Intel Corp',	'Intuit Inc',	'Intuitive Surgical Inc',	
               'IDEXX Laboratories Inc',	'J.B. Hunt Transport Services InC',	'JD.com Inc',	
               'KLA Corp',	'Kraft Heinz Co',	'Lam Research Corp',	'Liberty Global PLC',	
               'Liberty Global PLC',	'Lululemon Athletica Inc',	'Mercadolibre Inc',	
               'Marriott International Inc',	'Microchip Technology Inc',
               'Mondelez International Inc',	'Monster Beverage Corp',	'Microsoft Corp',	
               'Micron Technology Inc',	'Maxim Integrated Products Inc',	'Mylan NV',	
               'NetApp Inc',	'Netflix Inc',	'NetEase Inc',	'NVIDIA Corp',	'NXP Semiconductors NV',	
               'OReilly Automotive Inc',	'Paychex Inc',	'Paccar Inc',	'Booking Holdings Inc',
               'PayPal Holdings Inc',	'PepsiCo Inc.',	'Qualcomm Inc',	'Regeneron Pharmaceuticals Inc',
               'Ross Stores Inc','Sirius XM Holdings Inc',	'Skyworks Solutions Inc',	
               'Starbucks Corp',	'NortonLifeLock Inc',	'Synopsys Inc',	
               'Take-Two Interactive Software Inc',	'Tesla Inc',	'Texas Instruments Inc',
               'T-Mobile US Inc',	'Ulta Beauty Inc',	'United Airlines Holdings Inc',
               'Verisign Inc',	'Verisk Analytics Inc',	'Vertex Pharmaceuticals Inc',	
               'Walgreens Boots Alliance Inc',	'Western Digital Corp',	'Workday Inc',	
               'Wynn Resorts Ltd',	'Xcel Energy Inc',	'Xilinx Inc')

data <- data.frame(companies, symbol, stringsAsFactors = FALSE)


# Define server logic required to draw a time series
shinyServer(function(input, output) {
    
    selected_companies <- eventReactive(input$run, {
        input$var1_select
    })
    
    date_range <- eventReactive(input$run, {
        input$daterange1
    })
    
    output$var1_select <- renderUI(selectInput('var1_select','Select Companies',
                                   choices = companies, multiple = TRUE, selected = data$companies[1]))
    
    output$plot1 <- renderPlot({
        prices <- tq_get(data$symbol[data$companies %in% selected_companies()], from = date_range()[1], to = date_range()[2],
                         get = 'stock.prices')
        prices <- prices %>% inner_join(data)
        
        ggplot(prices, aes(x=date, y=close, color=companies)) + geom_line() +
            ggtitle('Daily Stock Prices For Selected NASDAQ Stocks') +
            xlab('Date') + ylab('Closing Price')

    })

})
