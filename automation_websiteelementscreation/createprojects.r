# serve website:
if (blogdown::hugo_version() != "0.58.3") blogdown::install_hugo(version ="0.58.3", force =TRUE)
options(blogdown.hugo.version = "0.58.3")
blogdown::serve_site()

###--------

library(readr)
library (dplyr)

#additional libraries for images stuff
library (magick)
library (data.table)

options(download.file.method="libcurl")

nanull <- function (isnullterm){
  if (is.null(isnullterm)){NA}else {isnullterm}
}

expandorcid <- function(orcid_numberslist){
  #to test:  orcid_numberslist =orcidnumberlist
  orcidlist =data.frame(orcid= orcid_numberslist)

  orcidlist$givenn_name = NA
  orcidlist$family_name = NA
  orcidlist$people_code = NA
  ## get links
  orcidlist$bio_fo = NA
  ## links
  orcidlist$githublink_fo=NA
  orcidlist$twitterlink_fo = NA
  orcidlist$picturelink_fo = NA
  orcidlist$lablink_fo = NA

  for (i in c(1: nrow(orcidlist))){
    a= as.character(orcidlist$orcid[i])
    print(a)
    b=rorcid::orcid_id(a)[[1]]
    urlname=b$`researcher-urls`$`researcher-url`$`url-name`
    url=b$`researcher-urls`$`researcher-url`$url.value

    # name
    orcidlist$givenn_name [i]= nanull(b$name$`given-names`)
    orcidlist$family_name [i]=nanull(b$name$`family-name`)
    ## add code without space and '
    orcidlist$people_code [i]=gsub("[^a-zA-Z0-9]", "-",tolower(paste0(b$name$`given-names`,"-",b$name$`family-name`)))

    orcidlist$bio_fo[i] = nanull(b$biography$content)
    ## links
    orcidlist$githublink_fo[i]= nanull(url[grepl("github", url)][1])
    orcidlist$twitterlink_fo[i] = nanull(url[grepl("twitter", url)][1])
    orcidlist$picturelink_fo[i] = nanull(url[grepl("picture", urlname)][1])
    orcidlist$lablink_fo[i] = nanull(url[grepl("lab", urlname)][1])
  }
  return(orcidlist)
}

repl_from_orcid <- function (ori,orcid){
  if (is.na(orcid)){ori} else {orcid}
}

###----------------------------------PROJECTS--PROJECTS--PROJECTS (with links to people)--
##get folder with the information sheets
seafilefolder= "C:/Users/juliencolomb/Seafile/SFB1315info/"
seafilefolder= "/Users/colombj/Documents/Seafile/SFB1315info/"

## read data
SFB_proj <- read_delim(paste0(seafilefolder,"sfb1315_project-people.csv"),
                       "\t", trim_ws = TRUE, skip = 1, na=character())

people_sfb <- read_delim("automation_websiteelementscreation/SFBpeopel_current.csv",
                         "\t", trim_ws = TRUE, skip = 0, na=c(""))
#people_sfb$orcidnum=as.character(substring(people_sfb$orcid,19))

## used to create people code
# people_sfb$people_code2 = NA
# a=people_sfb$Name %>% strsplit( " ")
# for (i in c(1: nrow(people_sfb))){
#   people_sfb$people_code2 [i]= tolower(paste0(a[[i]][length(a[[i]])-1], "-", a[[i]][length(a[[i]])]))
# }
# View(people_sfb)

# # Deprecated: done independently in create_peoplelist.R
# ## pull orcid info
#
# # get orcid numbers automaticall via a search
# orcidlist1= rorcid::orcid_search(grant_number = 327654276, rows =100)
#
# #Pool orcid and manual entries for orcid numbers:
#
# orcidnumberlist = unique(c(as.character(orcidlist1$orcid),as.list(people_sfb [people_sfb$orcidnum != "", ]%>% select (orcidnum))[[1]]))
#
# # Get information
#
# orcidlist1 = expandorcid(orcidnumberlist)
#
# # test all orcid names are in sfblist:
# testingnames=right_join(people_sfb, orcidlist1, by = c("people_code"))
# if(nrow(na.omit(testingnames[,2])) == nrow(testingnames[,2])) print ("all orcid entry in list") else View(testingnames)
#

orcidlist1 = expandorcid(unique(people_sfb$orcidnum[!is.na (people_sfb$orcidnum)]))
people_sfb2 = left_join(people_sfb, orcidlist1, by = c("people_code_orcid" = "people_code"))
# update info with orcid information as default.
people_sfb = people_sfb2 %>%
  mutate (orcid = paste0("https://orcid.org/",orcidnum))%>%
  mutate (github = ifelse (is.na(githublink_fo), github,githublink_fo)) %>%
  mutate (bio = ifelse (is.na(bio_fo), bio, bio_fo)) %>%
  mutate (twitter = ifelse (is.na(twitterlink_fo), twitter, twitterlink_fo)) %>%
  mutate (homepage = ifelse (is.na(lablink_fo), homepage, lablink_fo)) %>%
  mutate (avatar = ifelse (is.na(picturelink_fo),avatar ,picturelink_fo))%>%
  mutate (people_code = ifelse (!is.na(people_code_orcid), people_code_orcid,peoplecode))%>%
  mutate (people_code = paste0("sfb-",gsub("[^a-zA-Z0-9]", "",people_code)))%>%
  mutate (role2 = ifelse (role %in% c("Team Assistant","Data Curator","Network Coord\n","Coordinator"), "Staff", role) )  %>%
  mutate (Name =ifelse (is.na(Name),paste0(`First name`," ",`Last name`), Name))



  View(people_sfb)




##---------------------------------------- make projects



template = readLines("automation_websiteelementscreation/projects_template.md")

for (i in c(1: nrow(SFB_proj))){
  templatenew = template
  templatenew =sub ("THISISTHETITLE", SFB_proj$Title[i],templatenew)
  ### this needs to be changed:
  peoproj =people_sfb %>% filter(grepl (substring(SFB_proj$hash[i],9), Project)) %>%
    select(people_code)%>%
    pull()

  print(paste0( '"',paste0(peoproj, collapse = '","'), '"'))

  templatenew =sub ("heretheautors", paste0( '"',paste0(peoproj, collapse = '","'), '"'),templatenew)
  #templatenew =sub ("IMAGECAPTION", SFB_proj$featured_image_caption[i],templatenew)
  templatenew =sub ("IMAGECAPTION", "",templatenew)
  #### erase second line when RG gets the right function (parametrised url)
  MAINTEXT2 = paste0('<iframe src ="https://sdash.sourcedata.io/?search=',SFB_proj$hash[i],'" height=1000px width=90% ></iframe>')

  #MAINTEXT2 = paste0('<iframe src ="https://sdash.sourcedata.io/dashboard" height=1000px width=90% ></iframe>')
  templatenew =sub ("maintexthere", SFB_proj$description [i],templatenew )
  templatenew =sub ("SFgallerylink", MAINTEXT2,templatenew )

  outdirectory= paste0("content/project/",substring(SFB_proj$hash[i],9))
  dir.create(outdirectory, showWarnings = FALSE)
  writeLines(templatenew, paste0(outdirectory,"/index.md") )
  # deprecated, new images created
  #if (isTRUE(SFB_proj$new_image[i] == "1")) file.copy (paste0(seafilefolder,"projectsimages/",substring(SFB_proj$hash[i],9),".png"),
  #                                             paste0(outdirectory,"/featured.png"), overwrite = TRUE)
}



###----------------------------------authors--authors--authors-- Make authors (only ones with update and code set)
## avatar will be in order: default avatar, twitter avatar, orcid linked avatar, manually added avatar in folder



update = people_sfb #%>% filter (people_code != "") #%>% filter(update == "yes")
update[is.na(update)] <- ""

p_template =  readLines("automation_websiteelementscreation/authors_template.md")

for (i in c(1: nrow(update))){
  # create directory
  pdirectory =paste0("content/authors/",update$people_code[i])
  dir.create(pdirectory, showWarnings=FALSE)

  # create index
  templatenew = p_template
  if (update$Name[i]== "") {templatenew = sub ("DISPLAYNAME",paste0(update$`Last name`[i], " ", update$`First name`[i]),templatenew)}
  templatenew =sub ("DISPLAYNAME", update$Name[i],templatenew)
  templatenew =sub ("USERNAME", update$people_code[i],templatenew)
  templatenew =sub ("HEREROLE", update$role[i],templatenew)
  templatenew =sub ("HEREROL2", update$role2[i],templatenew)
  templatenew =sub ("HERESHORTBIO", gsub("\"","'",update$bio [i]),templatenew)

  SOCIAL = paste0("\n- icon: globe \n  icon_pack: fas \n  link: ",update$homepage[i])
  HERETEXT = update$bio [i] # bigraphy text is either orcid bio, twitter description  (in order of preference)

  ## twitter info integration, most rewritten if orcid info exists
  if (update$twitter [i] != ""){
    SOCIAL = paste0(SOCIAL,"\n- icon: twitter \n  icon_pack: fab \n  link: ",update$twitter [i])

    ## add twitter description, will be rewritten if there are orcid information
    tweetname = substring(update$twitter[i],21)
    a=rtweet::lookup_users(tweetname)
    HERETEXT = a$description

    ## add twitter picture, will be rewritten if there are orcid information, will not write if there is already a picture
    if (!file.exists(paste0(pdirectory,"/avatar.jpg"))){

      download.file(sub("_normal.", ".",a$profile_image_url),paste0(pdirectory,"/avatar.jpg"), mode ="wb")
    }

  }

  ## orcid info link + bio
  if (update$orcid[i] != "https://orcid.org/NA"){
    SOCIAL = paste0(SOCIAL,"\n- icon: orcid \n  icon_pack: ai \n  link: ",update$orcid[i])
if (!is.na(update$bio_fo [i]))    HERETEXT = update$bio_fo [i] # bigraphy text is either orcid bio, twitter description  (in order of preference) or default text
  }

  ## add github link
  if (update$github[i] != ""){
    SOCIAL = paste0(SOCIAL,"\n- icon: github \n  icon_pack: fab \n  link: ",update$github[i])
  }

  ## add avatar picture
  if (update$avatar[i] != "" & update$avatar[i] != "done"){
    tryCatch(download.file(update$avatar[i],paste0(pdirectory,"/avatar.jpg"), mode ="wb", quiet = FALSE),
             error = function(e) print(paste('avatar not downloaded ')))


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
featureimage <- function(theproject,people_sfb = people_sfbh,   heightfeature = 230,
                         border =3,
                         widthfeature = 450, title =FALSE) {

  ## getting people slide:
  # selecting people from that project, who have an author page:

  #goodone =lapply (people_sfb$Project, function (x){ theproject %in% names(fread(text=paste0("\n ",x)))})
  #selectedpeople =people_sfb[unlist(goodone),] %>% filter (people_code != "")
  selectedpeople =people_sfb %>% filter(grepl (pattern=theproject, Project))
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
  imagemain = image_read("static/img/icon-512.png") %>%
    image_resize(paste0((widthfeature-Pwidth-2*border)/1.5,"x", (heightfeature-2*border)/1.5) ) %>%
    image_extent (paste0(widthfeature-Pwidth-2*border,"x", heightfeature-2*border), gravity = "center", color = "white")%>%
    image_border(geometry = paste0(border,"x",border))

  if (file.exists(paste0(seafilefolder,"projectsimages/", theproject,".png"))) {
    imagemain=
      paste0(seafilefolder,"projectsimages/", theproject,".png") %>%
      image_read() %>%
      image_resize(paste0(widthfeature-Pwidth-2*border,"x", heightfeature-2*border)) %>%
      image_extent (paste0(widthfeature-Pwidth-2*border,"x", heightfeature-2*border), gravity = "south", color = "white")%>%
      image_border(geometry = paste0(border,"x",border))
  }

  if (title) {imagemain= imagemain %>% image_convert( colorspace = 'RGB') %>%
    image_annotate(theproject, gravity = "northeast", location ="+10+10",size = "40", boxcolor = "white")
}
  Image = image_append(c(imagemain, imagep))
  return (Image)
}

# for testing
# featureimage ("A04",people_sfb, heightfeature = 460,border =5,widthfeature = 900)


## create and save the file
for (theproject in substring (SFB_proj$hash,9)) {
  #print (theproject)
  theproject %>%
    featureimage(people_sfb, heightfeature = 460,border =5,widthfeature = 900) %>%
    image_write(path = paste0("content/project/",theproject,"/featured.png"), format = "png")
}

# for (theproject in substring (SFB_proj$hash,9)) {
#   print (theproject)
#   theproject %>%
#     featureimage(people_sfb,border = 2, title = TRUE) %>%
#     image_write(path = paste0("imageoutputtest/",theproject,"_featured.png"), format = "png")
# }
#
#
#
#
# ### helper functions used before
# ### add project to people list
#
# # people_sfb$project = NA
# #
# # projectlists= substring (SFB_proj$hash,9)
# # for (project in projectlists){
# #   print (project)
# #   people_sfb$project[grep(project, people_sfb$bio)] = project
# # }
# #
# # people_sfb$project
# # write_delim(people_sfb,paste0(seafilefolder,"sfb1315_people2.csv"),
# #             delim="\t")
#
# i=1
# substring(SFB_proj$hash [i],9)
#
# peoproj =people_sfb %>% filter(grepl (substring(SFB_proj$hash [i],9), project)) %>%
#   select(people_code)%>%
#   pull()
#
# paste0( '"',paste0(peoproj, collapse = '","'), '"')
#
