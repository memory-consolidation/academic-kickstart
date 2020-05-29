library (readxl)
library (dplyr)

#read spreadsheets
PI <- read_excel("~/Downloads/SFB personnel.xlsx",
                 sheet = 1, skip = 2)[,1:7]
headershere = names(PI)

postdoc <- read_excel("~/Downloads/SFB personnel.xlsx",
                 sheet = 2, skip = 2)[,1:7]

phd<- read_excel("~/Downloads/SFB personnel.xlsx",
                 sheet = 3, skip = 2)[,1:7]

staff<- read_excel("~/Downloads/SFB personnel.xlsx",
                 sheet = 4, skip = 3)[,c(1:3,5:8)]

names(staff) = headershere
staff=staff %>% mutate (role =PI)%>%filter (Email != "Email")

# add roles

addrole <- function(peopletab = PI,posit ="Principal Investigator", headers = headershere) {
  #peopletab =postdoc
  #posit ="postdoc"
  names(peopletab) = headers
  peopletab$`Last name`[nrow(peopletab)] ="Alumni"
  peopletab$role = paste0("Associated " ,posit)
  peopletab$role [1:grep("Associated", peopletab$`Last name`)] =posit
  peopletab$role [grep("Alumni", peopletab$`Last name`)[1]: nrow(peopletab)] = "Alumni"
  peopletab=peopletab %>%
    #mutate (role= ifelse (associated, paste0("associated" ,posit), posit)) %>%
    filter (!is.na(`First name`)) %>%
    filter (Email != "Email") #%>%
    #select(-associated)
  peopletab$role
  return(peopletab)
}

allpeople = rbind(addrole(),addrole(postdoc, "postdoc"),addrole(phd, "PhD student"), staff)
allpeople$peoplecode = gsub("[^a-zA-Z0-9]", "-",tolower(paste0(allpeople$`First name` ,"-",allpeople$`Last name`)))

write.csv (allpeople, file = "automation_websiteelementscreation/newlistfromgoogle.csv")

## get orcid data

orcidlist1= rorcid::orcid_search(grant_number = 327654276, rows =100)
orcidlist1$peoplecode = gsub("[^a-zA-Z0-9]", "-",tolower(paste0(orcidlist1$first ,"-",orcidlist1$last)))
#write.csv (orcidlist1, file = "automation_websiteelementscreation/newlistfromorcidsearch.csv")

# get previous information

SFBlist_old <- read_delim("automation_websiteelementscreation/sfb1315_peopleinfo2.csv",
                            "\t", escape_double = FALSE, trim_ws = TRUE)

# mix informations
## new orcid number via search into info list
if (!all (orcidlist1$orcid %in% SFBlist_old$orcidnum)) {
  a=left_join (SFBlist_old, orcidlist1, by= c("people_code_orcid" = "peoplecode"))
  a$orcidnum [a$orcidnum ==""] = NA
  a$orcidnum = ifelse (is.na(a$orcidnum),a$orcid.y, a$orcidnum)
  SFBlist_new = a [1:(length(a)-length(orcidlist1)+1)]
}else {SFBlist_new = SFBlist_old}

if (!all (orcidlist1$orcid %in% SFBlist_new$orcidnum)) print ("something wrong with adding orcid numbers")

## mix old information into updated sfb people list

SFBpeopel_current = left_join (allpeople,SFBlist_new, by =c("peoplecode" = "peoplecode_sfblist"))


# write outputs
write.table (SFBpeopel_current, file = "automation_websiteelementscreation/SFBpeopel_current.csv", sep = "\t", na = "",row.names = FALSE)
write.table (SFBlist_new, file = "automation_websiteelementscreation/sfb1315_peopleinfo2.csv", sep = "\t", row.names = FALSE)

SFBpeopel_current$peoplecode
