library(RJSONIO)
library(plyr)
data.set = ldply(fromJSON(content="src/sample_json.txt"))
maml.mapOutputPort("data.set");
