library(readr)
library (dplyr)
##get folder with the information sheets
seafilefolder= "C:/Users/juliencolomb/Seafile/SFB1315info/"

## make projects

SFB_proj <- read_delim(paste0(seafilefolder,"sfb1315_project-people.csv"),
                       "\t", trim_ws = TRUE, skip = 1, na=character())

template = readLines("automation_websiteelementscreation/projects_template.md")

for (i in c(1: nrow(SFB_proj))){
  templatenew = template
  templatenew =sub ("THISISTHETITLE", SFB_proj$Title[i],templatenew)
  templatenew =sub ("heretheautors", as.character(SFB_proj$People_linked[i]),templatenew)
  templatenew =sub ("IMAGECAPTION", SFB_proj$featured_image_caption[i],templatenew)
  templatenew =sub ("maintexthere", SFB_proj$description [i],templatenew)

  outdirectory= paste0("content/project/",substring(SFB_proj$hash[i],9))
  dir.create(outdirectory)
  writeLines(templatenew, paste0(outdirectory,"/index.md") )
  if (isTRUE(SFB_proj$new_image[i] == "1")) file.copy (paste0(seafilefolder,"projectsimages/",substring(SFB_proj$hash[i],9),".png"),
                                               paste0(outdirectory,"/featured.png"), overwrite = TRUE)
}



## Make authors
## avatar will be in order: default avatar, twitter avatar, manually added avatar in folder

people_sfb <- read_delim(paste0(seafilefolder,"sfb1315_people.csv"),
                         "\t", trim_ws = TRUE, skip = 0, na=character())

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
    if (! is.null(rorcid::orcid_id(substring(update$orcid[i],19))$biography) ){
      HERETEXT = rorcid::orcid_bio (substring(update$orcid[i],19))$content
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
