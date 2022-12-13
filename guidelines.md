## Development and Change Guidelines

This document describes the guidelines for ONVIF specification evolution. Its goal is to provide a transparent and open mechanism. 
The ONVIF Technical Committee implements the process described below when merging changes from internal or external contributors. 

## Specification Change Categories

Changes should fall into the following three categories:

* Clarification. The current description either doesn't make sense, is ambiguous, overly complicated, or unclear.

* Consistency. A portion of the specification is not consistent with the rest, or contraditcs to underlying specifications.

* New functionality. The proposal adds one or more features to the specifications.

## Repository branches

ONVIF will maintain the following active branches:

* master - Current stable version reflecting the released specifications.  
  Update from development branches only.

* development - Development branch for next version  
  Change requests for clarifications and consistency should be submitted to this branch. Minimal additions or features in 
  IPR review may be submitted to this branch.
  Implementers may use this branch. However in the unlikely case of IPR notices indiviual changes may be revoked.

Beside the above branches the following temporary branches may be established:  
* issue-xx-yyyyy - Change request for issue XX with short title YYYY.  

* xxxx/yyyy-zzzz - Feature branch for group xxxx with short title yyyy-zzzz.  ## Specification Change Process

## Specification change workflow

Any party may file a change request. A change request must include a complete change proposal and be 
submitted as pull request to one of the development branches. 
The comment of a pull request shall include the following information:  
* Reason: containing a problem description and a description of the solution proposal.
* Compatibility analysis: An analysis describing possible impact on forward and or backward compatibility. 

A pull request to any of the development branches shall be reviewed by at least two TC member companies before being merged. 
Note that a pull request typically also needs to await a 14 day review period in order to enable any interested party to review or comment.

For larger additions affecting more than a simple type please see section "Feature Development Process" below. 

## Feature Development Process

New features shall not be developed on development branches but in separate feature branches. 
Feature branches may be part of the main ONVIF specification repository, but are typically located in separate repositories.

* Once an author or group has completed the specification development for a feature the respective feature needs to be verified by writing and executing test cases.
* When all activities have been completed the pull request shall include the following information:
  * Reason: containing a problem description and a description of the solution proposal.
  * Compatibility analysis: An analysis describing possible impact on forward and or backward compatibility. 
  * Unit tests covering the additional features
  * Information which parties implemented client and server side as well as a test report from at least two different entities.

## Tools

All documents are designed such that they can be edited by any text editor. Better use e.g. 
* Notepad++ www.notepad-plus-plus.org with XML Tools plugin for syntax checking. 
* Wysiwyg editing is supported by
  * Oxygen www.oxygenxml.com
  * XMLmind www.xmlmind.com/xmleditor/download.shtml
    Be careful when using this editor because it tends to reformat the complete document. Usage for creating snippets is ok.

For text documents DocBook5 is used. For details on DocBook editing and formatting see https://docbook.org/ .

For instructions regarding document and wsdl preview see [link](doc/README.md).
## Maintainers

The elected ONVIF Technical Committee members act as change control board and maintainers of this repository. Typically any change proposals is kept pending for at least two weeks to collect comments. Decisions on pull requests and issues will be documented in place. 

Note that this repository sole purpose is technical specification evolution. Any possible product incompatiblities must be directed to vendors. 

## Participation

While governance of the specification is the role of the ONVIF Technical Committee, the evolution of the specification happens through the participation of members of the developer community at large. 
Any person willing to contribute to the effort is welcome, and contributions may include filing or participating in issues, creating pull requests, or helping others with such activities.

