### Connect to Cytoscape via CyREST
#
# This script will show you how to connect to Cytoscape from R using CyREST.  It will also cover
# the installation and check of Cytosacpe Apps and demonstrate some basic functionality of CyREST,
# commands and r2cytoscape.
#
# This is helpful to run PRIOR to workshops and other tutorials to mitigate troubleshooting time.

#### First, install libs
# if any of these do not load properly, please refer to check-library-installation.R for more details:
# https://github.com/cytoscape/cytoscape-automation/tree/master/for-scripters/R
library(pacman)
p_load(RJSONIO,httr,XML,r2cytoscape)


#### Next, setup Cytoscape
# - Launch Cytoscape on your local machine. If you haven't already installed Cytoscape, then download the latest version from http://cytoscape.org.
# - Install the STRING app, if you haven't already: http://apps.cytoscape.org/apps/stringapp 
# - Leave Cytoscape running in the background during the remainder of the tutorial.

#### Test connection to Cytoscape
# **port.number** needs to match value of Cytoscape property: rest.port (see Edit>Preferences>Properties...); default = 1234
# port.number = 1234
# base.url = paste('http://localhost:',port.number,'/v1',sep="")
checkCytoscapeVersion()

#### Test installed apps for Cytoscape
if("string" %in% commandHelp("")) print("Success: the STRING app is installed") else print("Warning: STRING app is not installed. Please install the STRING app before proceeding.")
if("diffusion" %in% commandHelp("")) print("Success: the Diffusion app is installed") else print("Warning: Diffusion app is not installed. Please install the Diffusion app before proceeding.")

###############################
#### Now it gets interesting...
###############################

# Let's create a Cytoscape network from some basic R objects
mynodes <- data.frame(id=c("node 0","node 1","node 2","node 3"), 
                      group=c("A","A","B","B"), # optional
                      stringsAsFactors=FALSE)
myedges <- data.frame(source=c("node 0","node 0","node 0","node 2"), 
                      target=c("node 1","node 2","node 3","node 3"),
                      interaction=c("inhibits","interacts","activates","interacts"),  # optional
                      weight=c(5,3,5,9), # optional
                      stringsAsFactors=FALSE)
network.name = "myNetwork"
collection.name = "myCollection"

# create network
network.suid <- createNetwork(mynodes,myedges,network.name,collection.name)


# create style with node attribute-fill mappings and some defaults
style.name = "myStyle"
defaults <- list(NODE_SHAPE="diamond",
                 NODE_SIZE=30,
                 EDGE_TRANSPARENCY=120,
                 NODE_LABEL_POSITION="W,E,c,0.00,0.00")
nodeLabels <- mapVisualProperty('node label','id','p')
nodeFills <- mapVisualProperty('node fill color','group','d',c("A","B"), c("#FF9900","#66AAAA"))
arrowShapes <- mapVisualProperty('Edge Target Arrow Shape','interaction','d',c("activates","inhibits","interacts"),c("Arrow","T","None"))
edgeWidth <- mapVisualProperty('edge width','weight','p')

#create style
createStyle(style.name, defaults, list(nodeLabels,nodeFills,arrowShapes,edgeWidth))
applyStyle(style.name)

#check out the marquee style!
applyStyle('Marquee')

# list of available visual properties
?mapVisualProperty

############################################
#### Browse Available Commands and Arguments
############################################

# r2cytoscape helper functions
help(package=r2cytoscape)

# Open swagger docs for live instances of CyREST API and CyREST-supported commands:
openCySwagger()  # CyREST API
openCySwagger("commands")  # CyREST Commands API

#List available commands and arguments in R. Use "help" to list top level:
commandHelp("help")  

#List **network** commands. Note that "help" is optional:
commandHelp("help network")  

#List arguments for the **network select** command:
commandHelp("help network select")  

#### Syntax reference and helper functions
# Syntax examples. Do not run this chunk of code.

### CyREST direct
# queryURL = paste(base.url,'arg1','arg2','arg3',sep='/') # refer to Swagger for args
# res = GET(queryURL) # GET result object
# res.html = htmlParse(rawToChar(res$content), asText=TRUE)  # parse content as HTML

### Commands via CyREST
# queryURL = command2query('commands and args') # refer to Swagger or Tools>Command Line Dialog in Cytoscape
# res = GET(queryURL) # GET result object
# res.html = htmlParse(rawToChar(res$content), asText=TRUE)  # parse content as HTML
## ...using helper function
# res.list = commandRun('commands and args') # parse list from content HTML


#### Ok, now you are ready to work with some real data!  See advanced tutorials...
