# s3-cache-orb

A simple CircleCI Cache Implementation using an S3 bucket 

#### An example config demonstrating the cache implementation

```
version: 2.1
parameters:
  cache-file:
    type: string
    default: "my-cache"
orbs:
  orbdemo: vjpandian/s3-cache@0.0.1
jobs:
  cache-test:
    machine: true
    resource_class: vjpandian/vj-macbook
    steps:
      - run: echo "hello" > << pipeline.parameters.cache-file >>
      - orbdemo/save-cache:
          cache-path: << pipeline.parameters.cache-file >>
          cache-key: << pipeline.git.revision >>
      - orbdemo/restore-cache:
          cache-key: << pipeline.git.revision >>
      - run: 
          name: run a step when caches are working properly
          command: echo "this steps will run when caches are working properly"
          when: on_success

workflows:
  simple-cache-wf:
    jobs:
      - cache-test:
           context: org-global
```
