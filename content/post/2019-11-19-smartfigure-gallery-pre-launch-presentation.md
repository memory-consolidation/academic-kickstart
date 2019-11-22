---
title: SmartFigure gallery pre-launch presentation and feedback
author: julien colomb
date: '2019-11-19'
slug: smartfigure-gallery-pre-launch-presentation
categories:
  - report
tags:
  - feedback
  - sourcedata
  - data_management
subtitle: ''
summary: ''
authors: []
lastmod: '2019-11-19T12:56:44+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---


During the SFb1315 retreat, we had a 45 minute presentation of the smartFigure gallery concept and tool. The hands-on session that was planned had to be cut for both timing (1h was initially planned)
and technical (no stable internet connection) reasons.

We distributed the researchers in three groups, and Julien Colomb, Hannah Sonntag and Thomas Lemberger gave three different but similar presentation of the tool, and gather feedback from the researchers during the last 5-10 minutes of the presentation. Here we report that feedback. At the end, we develop a larger discourse about two specific topics: the research narative and the version control system.

# Feedback

## New scenario: reporting null and problematic results

In the present publish or perish scientific communication system, there is no room for critical presentation of one own's results or tool. Presenting difficult results in the SmartFigure gallery might become a way to share knowledge about non-published difficulties and present puzzling results to get feedback inside the SFB. Indeed, someone in the consortium might well know of technical insights that explain the results.

One can also imagine to be able to seamlessly publish these results in micropublication, if they do not fit in the bigger picture.



## Usage: upload


We discussed how to motivate users to upload figures, and what could be useful for them. The first element was to be able to work with a different group: share the figure with only your lab for instance. This is a critical feature we are already working on, and users will be able to **create their own goups** and share figures with different groups.

In addition, giving a **timestamp** to the figures could help with recognition of the work (as well as figure filtering and search). Users ask for the possibility to write **mathematical equation**, this could be implemented using a markdown format.

Last but not least, there is a need for a way to **re-use the metadata** entered for a figure. This might be important for new versions of the same figure, but also as template for new figures.


Irrespective of the feedback, we thought about adding a "help wanted" button, such that the users can notify specific people they are seeking for comments and help. This would be combined with a self-commentary to explain what kind of help is requested.


## Usage, read


On the one hand, it is clear for everyone that people will not go regularly on the platform to read/search for new figures. Getting a good **hierachy and sorting of smartfigures** on the first page of the gallery will probably not be sufficient to make people visit the gallery, and we need to find a way to deliver relevant figures to the users, probably via **email allerts and summaries**. One related function would be to be able to **follow** particular users, groups or figures to get allerts specific for these follows.  

On the other hand, people are afraid that the narative of the research gets lost in a figure based system and we need to find a way to bring the narative back. This question is discussed more intensively at the end of the article.


## Publication of SmartFigure

While it is not essential to publish SmartFigures per se, it is a goal for both the data management project and the sourcedata team. The implementation of these elements are postponed to a later time point, but we will start thinking and planning these. 

Note that Smartfigures can be panels of larger figures. This means we might implement ways to **automatise the concatenation of different SmartFigures into panels of figures** (maybe in collaboration with the [texture project](https://github.com/substance/texture)). The metadata should also be worked to add (only non-redundent) information into a draft figure caption and a draft material and method section of a paper.


Upon publication, the SmartFigure should be saved in a different open platform, get a doi, be tagged with a license (CC-BY per default, open to other options ?) and be linked with the publication and the figure in it. There are also concerns with new figure version until and beyond that point in time. 



## Publication of SmartFigure

After discussion, the implementation of these elements will be postponed to a later time point. We will need to think about:

- New version for publication (cleaner)
- How to license the work
- Getting a PID (doi)
- Combine panels into one figure *
- Combine metadata *

* may be taken up by the texture project.

## Other

Users will need a way to reference the SmartFigure, so we need to assign **permanent identifiers** for that. We will not work with doi to reduce costs and avoid unnecessary doi creation. An internal system should be sufficient. Linked to this problem, we should always put some thought on making a decentralised system for SmartFigures, PID should also link to specific instances of the application.

In terms of commenting, we should speed up slack integration. One way to deal with this might be to use an **e-mail integrated commenting** (like for GitHub comments, where you can reply either online or directly via emails) and add slack-email integration.

We discussed the usage of the platform and the **kind of figures** one would want to upload. While we were mostly thinking people would like to use the platform for data representation figures, we got a lot of different use case, the list is probably not exhaustive, we need to think about ways to label the figures differently, if needed.

    - Whiteboards: result of meetings as drawn on the board could be photographed and shared via the SmartFigure
    - visual abstract: these figures represent the take home message of a publication.
    - Hyspothesis: These figures represent a model or an hypothesis one is trying to prove or destroy.
    - experimental design: This may include information on groups, sample size, power analysis, expectations,...
    - visual protocol: these figures present the method used in the experiment(s)
    
It would be interesting/necessary to be able to **link SmartFigures together**, one would be able to browse them. One use case would be: someone got allerted about a new visual abstract, he got interested and looks at a key result. To better understand the result, he browse to the experimental protocol figure and the experimental design figures linked to that experiment.
    


# Getting a narative

This is a huge concern, as figures alone are not sufficient to grasp the research question and the implication of the results. At the moment, it is tempting to use the caption field for adding background information, something which is not good on the long term. We should therefore urgently **add another text entry field**. 

In addition, we need to think about better ways to implement the narative into the SmartFigure gallery. We differencate the problems of what information should be delivered, and how this information could be delivered.

## The what

- The research question asked.
- Relation to memory consolidation
- The experimental design
- Result description
- Statistical approach
- Main interpretation
- Future questions


## The How

- Additional boxes with either text, link to other SmartFigures or external links (for example a blog post):
    - how many
    - SmartTag integration ?
- Template for one extra story telling summary field (and, but, therefore structure ?)

One could also think that each project gets a initial meta-smartFigure which could be either a figurative summary (visual abstract) or a poster explaining the project itself. Each new SmartFigure could then be linked to that project meta-smartFigure (also inheriting smartTags and maybe other metadata fields from it). A special field would then encourage the author to explain what the new piece of information is bringing to the project?

# version control

We should think about the structure of the SmartFigure, especially the links (to other file, to other smartfigures) and see what can be modified, and why it matters to keep information about the changes. Accordingly, one needs to think about how comments are saved and linked, and how the information can be kept (or not) when a new version appears.

As a first food for thought, here is a proposition:

- Uploaded files are not version controlled (new files -> old file is trashed).
- A smartfigure gets a PID when saved the first time.
- As long as the picture is not changed, a log of changes (and any saved text) is saved, but no new versions are created.
- If the picture is changed or if the sharing status of the figure change, a new version of the SmartFigure is created:

    - gets a new pid
    - gets a link to older version of the figures (and their PIDs)
    - the user is asked whether the comments should be imported to the new figure.
    - the user is asked whether the older version of the figure can be archived/trashed
