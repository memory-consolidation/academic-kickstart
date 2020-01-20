library(readr)
library (dplyr)

#additional libraries for images stuff
library (magick)
library (data.table)



##get folder with the information sheets
seafilefolder= "C:/Users/juliencolomb/Seafile/SFB1315info/"

## read data
SFB_proj <- read_delim(paste0(seafilefolder,"sfb1315_project-people.csv"),
                       "\t", trim_ws = TRUE, skip = 1, na=character())

people_sfb <- read_delim(paste0(seafilefolder,"sfb1315_people.csv"),
                         "\t", trim_ws = TRUE, skip = 0, na=character())

##---------------------------------------- make projects



template = readLines("automation_websiteelementscreation/projects_template.md")

for (i in c(1: nrow(SFB_proj))){
  templatenew = template
  templatenew =sub ("THISISTHETITLE", SFB_proj$Title[i],templatenew)
  templatenew =sub ("heretheautors", as.character(SFB_proj$People_linked[i]),templatenew)
  templatenew =sub ("IMAGECAPTION", SFB_proj$featured_image_caption[i],templatenew)
  MAINTEXT2 = paste0('<iframe src ="https://sdash.sourcedata.io/dashboard" height=1500px width=90% ></iframe>')
  templatenew =sub ("maintexthere", SFB_proj$description [i],templatenew )
  templatenew =sub ("SFgallerylink", MAINTEXT2,templatenew )

  outdirectory= paste0("content/project/",substring(SFB_proj$hash[i],9))
  dir.create(outdirectory, showWarnings = FALSE)
  writeLines(templatenew, paste0(outdirectory,"/index.md") )
  # deprecated, new images created
  #if (isTRUE(SFB_proj$new_image[i] == "1")) file.copy (paste0(seafilefolder,"projectsimages/",substring(SFB_proj$hash[i],9),".png"),
  #                                             paste0(outdirectory,"/featured.png"), overwrite = TRUE)
}



##---------------------------------------- Make authors (only ones with update and code set)
## avatar will be in order: default avatar, twitter avatar, manually added avatar in folder



update = people_sfb %>% filter(update == "yes") %>% filter (people_code != "")

p_template =  readLines("automation_websiteelementscreation/authors_template.md")

for (i in c(1: nrow(update))){
  # create directory
  pdirectory =paste0("content/authors/",update$people_code[i])
  dir.create(pdirectory)

  # create index
  templatenew = p_template
  templatenew =sub ("DISPLAYNAME", update$Name[i],templatenew)
  templatenew =sub ("USERNAME", update$people_code[i],templatenew)
  templatenew =sub ("HEREROLE", update$role_group[i],templatenew)
  templatenew =sub ("HERESHORTBIO", update$bio [i],templatenew)

  SOCIAL = paste0("\n- icon: globe \n  icon_pack: fas \n  link: ",update$homepage[i])
  HERETEXT = update$bio [i] # bigraphy text is either orcid bio, twitter description or this (in order of preference)

  ## twitter info integration
  if (update$twitter [i] != ""){
    SOCIAL = paste0(SOCIAL,"\n- icon: twitter \n  icon_pack: fab \n  link: ",update$twitter [i])

    ## add twitter description, will be rewritten if there are orcid information
    tweetname = substring(update$twitter[i],21)
    a=rtweet::lookup_users(tweetname)
    HERETEXT = a$description

    ## add twitter picture
    if (!file.exists(paste0(pdirectory,"/avatar.jpg"))){
      download.file(a$profile_image_url,paste0(pdirectory,"/avatar.jpg"), mode ="wb")
    }
  }

  ## orcid info integration
  if (update$orcid[i] != ""){
    SOCIAL = paste0(SOCIAL,"\n- icon: orcid \n  icon_pack: ai \n  link: ",update$orcid[i])

    ## get biography from orcid
    if (! is.null(rorcid::orcid_id(substring(update$orcid[i],19))[[1]]$biography$content) ){
      HERETEXT = rorcid::orcid_id(substring(update$orcid[i],19))[[1]]$biography$content
    }
  }

  ## add github link
  if (update$github[i] != ""){
    SOCIAL = paste0(SOCIAL,"\n- icon: github \n  icon_pack: fab \n  link: ",update$github[i])
  }

  templatenew =sub ("HERESOCIAL", SOCIAL,templatenew)

  templatenew =sub ("HERETEXT", HERETEXT,templatenew)

  writeLines(templatenew, paste0(pdirectory,"/_index.md") )

  # add default avatar image if none present:
  if (!file.exists(paste0(pdirectory,"/avatar.jpg"))){
    file.copy ("automation_websiteelementscreation/avatar.jpg",
               paste0(pdirectory,"/avatar.jpg"))
  }


}

# for tests
#writeLines(templatenew, "test.md" )


##---------------------------------------- Featured images (based on data read above)


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
      image_modulate( saturation = 10)%>%
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

# for testing
# featureimage ("A04")


## create and save the file
for (theproject in substring (SFB_proj$hash,9)) {
  #print (theproject)
  theproject %>%
    featureimage(people_sfb,border = 2) %>%
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
