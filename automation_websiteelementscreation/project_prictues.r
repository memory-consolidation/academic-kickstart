# this script will change the project images to force a particular size and add pictures of the "authors"
library (magick)
library (readr)
library (dplyr)
library (data.table)

# variables, deprecated, we now use a function see loop below
# heightfeature = 300
# border =3
# widthfeature = 200



# read data
seafilefolder= "C:/Users/juliencolomb/Seafile/SFB1315info/"
SFB_proj <- read_delim(paste0(seafilefolder,"sfb1315_project-people.csv"),
                       "\t", trim_ws = TRUE, skip = 1, na=character())

people_sfbh <- read_delim(paste0(seafilefolder,"sfb1315_people.csv"),
                         "\t", trim_ws = TRUE, skip = 0, na=character())


# function to create image from the main image given on seafile and avatars  given in website (can be set with createprojects.r)
featureimage <- function(project,people_sfb = people_sfbh,   heightfeature = 230,
                         border =3,
                         widthfeature = 450) {

  ## getting people slide:
  # selecting people from that project, who have an author page:
  goodone =lapply (people_sfb$project, function (x){ project %in% names(fread(text=paste0("\n ",x)))})
  selectedpeople =people_sfb[unlist(goodone),] %>% filter (people_code != "")
  # get and append all people images, + resiz

  imagep = image_blank (77,heightfeature)
  if (length (selectedpeople$people_code)> 0){
    peoplefaces_path = paste0("content/authors/",selectedpeople$people_code, "/avatar.jpg")

    imagep =
      image_read(peoplefaces_path) %>%
      image_resize("100x")%>%
      image_crop ("100x100", gravity ="Center")%>%
      image_annotate(selectedpeople$Name, gravity = "south", size = "9", boxcolor = "light grey")%>%
      image_append( stack = TRUE) %>%
      image_resize(paste0("77x", heightfeature)) %>%
      image_extent (paste0("77x", heightfeature), gravity = "North")
  }


  Pwidth= image_info(imagep)$width
  ## get main image, box around it, and append with people slider
  imagemain = image_blank (widthfeature-Pwidth-2*border, heightfeature-2*border)
  if (file.exists(paste0(seafilefolder,"projectsimages/", project,".png"))) {
    imagemain=
      paste0(seafilefolder,"projectsimages/", project,".png") %>%
      image_read() %>%
      image_resize(paste0(widthfeature-Pwidth-2*border,"x", heightfeature-2*border)) %>%
      image_extent (paste0(widthfeature-Pwidth-2*border,"x", heightfeature-2*border), gravity = "Center")%>%
      image_border(geometry = paste0(border,"x",border))
  }


  Image = image_append(c(imagemain, imagep))
  return (Image)
}


# create and save the file
for (theproject in substring (SFB_proj$hash,9)) {
  print (theproject)
  theproject %>%
    featureimage(heightfeature = 250,
                 border =3,
                 widthfeature = 300 ) %>%
    image_write(path = paste0("content/project/",theproject,"/featured.png"), format = "png")
}




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
