## Original content
article:
http://www.objc.io/issue-10/networked-core-data-application.html

repo:
https://github.com/objcio/issue-10-core-data-network-application

server to run locally:
https://gist.github.com/chriseidhof/725946f0d02b17ced209

## Changes
- rewritten in Swift
- changed code structure a little bit
- unit tests for Core Data model and integration tests for Pods web service
- implemented find-or-create according to the Core Data	   Programming Guide

- extra little things:
  - wrapper for methods that take in NSErrorPointer to standardize their handling
  - custom UIStoryboard depedency injection
