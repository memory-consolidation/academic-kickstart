# this script will change the project images to force a particular size and add pictures of the "authors"
library (magick)
library (readr)
library (dplyr)
library (data.table)
# variables
heightfeature = 230
border =3
widthfeature = 450

# this will go into a loop for every project

project = "A04"

# read data
seafilefolder= "C:/Users/juliencolomb/Seafile/SFB1315info/"
SFB_proj <- read_delim(paste0(seafilefolder,"sfb1315_project-people.csv"),
                       "\t", trim_ws = TRUE, skip = 1, na=character())

people_sfb <- read_delim(paste0(seafilefolder,"sfb1315_people.csv"),
                         "\t", trim_ws = TRUE, skip = 0, na=character())


# get main image for project 1

project = "A04"
## getting people slide:

# selecting people from that project, who have an author page:
goodone =lapply (people_sfb$project, function (x){ project %in% names(fread(text=paste0("\n ",x)))})
selectedpeople =people_sfb[unlist(goodone),] %>% filter (people_code != "")
# get and append all people images, + resizt

peoplefaces_path = paste0("content/authors/",selectedpeople$people_code, "/avatar.jpg")

imagep =
  image_read(peoplefaces_path) %>%
  image_resize("100x")%>%
  image_annotate(selectedpeople$Name, gravity = "south", size = "10", boxcolor = "light grey")%>%
  image_append( stack = TRUE) %>%
  image_resize(paste0("77x", heightfeature)) #%>% print()

imagemain=
  paste0(seafilefolder,"projectsimages/", project,".png") %>%
  image_read() %>%
  image_resize(paste0(widthfeature-77,"x", heightfeature-2*border)) %>%
  image_extent (paste0(widthfeature-77,"x", heightfeature-2*border))%>%
  image_border(geometry = paste0(border,"x",border))

Image = image_append(c(imagemain, imagep))




### helper functions used before
### add project to people list

# people_sfb$project = NA
#
# projectlists= substring (SFB_proj$hash,9)
# for (project in projectlists){
#   print (project)
#   people_sfb$project[grep(project, people_sfb$bio)] = project
# }
#
# people_sfb$project
# write_delim(people_sfb,paste0(seafilefolder,"sfb1315_people2.csv"),
#             delim="\t")
