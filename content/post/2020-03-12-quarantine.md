---
title: Working from home
author: Julien Colomb
date: '2020-02-18'
slug: working-from-home
categories:
  - walkthrough
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2020-02-18T21:59:52+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

What does a researcher when he is asked to stay home, unable to collect new data? I will collect here some thought and experience gathered over the years. After giving links to good source of advice for home working in general, I will give some information specific for researchers.

This is a work in progress, please give comments and feedback here https://github.com/smartfigures-dar/feedback_repo/issues/new?assignees=jcolomb&labels=website&template=website-issue.md&title=

![](/post/2020-03-12-quarantine_files/home_office-01.svg)

# A desk at home!

Working from home is a bit different from working in the lab. I would encourage anyone of you to take 5 minutes to read advices form experts here: 

- https://www.jisc.ac.uk/blog/dont-forget-the-human-side-of-homeworking-11-mar-2020
- https://creativecommons.org/2020/03/13/advice-on-working-from-home/



In summary: 

- Prepare your working place (desk, chair)
- Keep your normal workday (morning) routine (including breaks)
- Keep social contacts
- Be flexible
 
> structure your day, welcome the interruptions and keep in touch.  I often break my day with a 'hi there' to a colleague, just to touch base. 
> ~Scott connor

# Possible tasks and how to prepare them

## Socializing

Reach out to people you want to work with on specific project, or colleagues you have not met for some time, ask for updates, give yours. Your social network is part of your academic success, give some of your time everyday to strengthen these bonds.

## Online presence

There are different ways to work on one's reputation online, but the main possibilities are getting an updated orcid profile, being active on twitter, and a personal blog. I do advice against spending time on google scholar, academia or researchgate, which have closed data scheme and opaque business models. You can also think about using instagram and youtube, but that requires more investment (see https://www.helmholtz-hzi.de/en/news-events/stories/online-visibility-from-analogue-researcher-to-online-scientist/)

- https://orcid.org : get an unique identifiers that you can use in your publication (papers, data-sets, software,...), that will be easier for anyone to know it is you and not someone with a similar name. In addition, the platform allows you to pull and add different information about yourself (publications, funding information, affiliation, education certificates,..), this information can the be used by other software (wikidata, impactstory, your university library,..) to build personal pages and department statistics. For instance, you can then get a complete scienceopen profile, as your orcid information can be pulled and updated automatically.
- https://twitter.com : give small updates on your work, connect with peers, comment others entries, stay up to date with news,... Be careful not to become addicted and reserve some time for twitter, the same way you should save time for your emails (i.e. do not check them outside of this reserved time)
- Blog platforms: While using wordpress.com is the easiest way to start, I would encourage you to use a static web generator and learn how to use [blogdown](https://bookdown.org/yihui/blogdown/index.html) (this website was created using that technology). It will allow you to reuse orcid information, keep a total control over the website, and create blog-posts including statistical analysis (written in R or python, and that will be updated with new/more data, bringing you closer to scientific reproducible reports).

## Reading papers

Let's start with the obvious: catch up with the literature can be done anywhere. If you need to access pay-walled papers, there is different ways:

- Get a VPN access to your university network (https://www.cms.hu-berlin.de/de/dl/netze/vpn/openvpn)
- use `unpaywall` on firefox to get a link to a legal copy of the article while browsing(if one exists)
- send a email/slack message to the authors or to someone who has access
- use a pirate website to get a copy illegally (https://en.wikipedia.org/wiki/Sci-Hub)

Do not forget to **use a reference manager** to gather article metadata during download, my favorite open source one is zotero: https://www.zotero.org (This will greatly facilitate your work when using these paper as reference in a future paper). You can add notes and tags into your reference manager directly.

Since you have quite some time free, you may try to make your remarks about the paper public. It can be a blog-post to share with your colleagues, or a more formal post-publication peer review (you can use https://www.scienceopen.com for that), or a comment or an email to the authors if the article is still in a preprint stage. 

## Writing papers (and documenting experiments)

You can start writing your next paper, even if you do not have much results yet. You can use the time to collect information you will need for the material and method section: write down your protocols, be sure to have all information needed to describe your material and animals. The Arrive checklist can help you: https://www.nc3rs.org.uk/sites/default/files/documents/Guidelines/NC3Rs%20ARRIVE%20Guidelines%20Checklist%20%28fillable%29.pdf

For genetic information, gather or request a MGI number for your animal strain: http://www.informatics.jax.org/home/strain (if it was already published, sometimes it is easier to search for the publication fist, and access the strain afterwards).

For material (plasmids, chemicals,..), check whether there is a RRID number (https://scicrunch.org/resources), or look for another way to uniquely identify the material. You may ask a colleague to check if the information is sufficient to reproduce the experiment.


## Analyzing (and organizing) your data

If you can not collect new data, you can still work on your data analysis. For this you will need your data (at least some of it). You can either get it on a external hard disk, or online on GIN http://www.g-node.org. If you go for the latter solution, you may use a template repository. Click `+ > Import repository` and use https://gin.g-node.org/larkumlab/Main_template as the clone address. Upload then data via the browser (drag and drop folders). The data curator team is preparing some teaching material to better introduce GIN to the SFB.

You may also use the time to investigate new ways to analyse your data, learning a programming language like R and python, and/or testing new algorithms and analysis. It might help to write readme files to describe the data-sets, maybe reorganize the files to facilitate the analysis (as well as adding metadata to  make the data re-usable in different contexts).

**Please reach out to the data curator if you need help to organize your data !**

## Computational project

If you do not have one, you might find a side project not involving animal experiments. Maybe you can access existing data (from your past experiments, from a lab mate or from an open data repository) and work on new ways to analyse it ?

 
>In 2011, my test device broke and I could not do any experiments for 8 months. I had to start a new project, and spent a lot of time working on the analysis of trajectories that had been started in the lab. It ended up being a great learning experience (I am now a decent R programmer), and got me 3 publications, two as first author.



# Learn new skills

Last but not least, you can spend time to learn new skills. There are a lot of free offers around, let it be programming, open source software, time management, project management, group moderation, open science topics, scientific writing,...

Some platforms to search for free courses:

- https://www.open.edu/
- https://www.edx.org/
- https://www.futurelearn.com
- https://www.coursera.org
