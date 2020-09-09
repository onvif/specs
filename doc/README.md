# ONVIF Technical Specifications
This folder contains the sources of the ONVIF Technical Specifications.

## Document preview

For a preview of the documents visit:  
  https://onvif.github.io/specs/doc/index.html

The same page is also served via a proxy fixing a github.io wsdl content-type issue:  
  https://onvif.org/github_specs/specs/doc/index.html

Note on branches and forks: the above links do not automatically update.

For security reasons browsers do not execute stylesheets when accessing local html files.
Use a web server for serving your specs checkout in order to view both wsdl and DocBook files.

One compact option is to use [MONGOOSE WEB SERVER](https://www.cesanta.com/binary.html) with
the following configuration

```
document_root <path-to-your-specs-checkout>
listening_port 80
extra_mime_types .xslt=application/xml,.wsdl=text/xml
```
