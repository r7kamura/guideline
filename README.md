# Guideline
Check your code

## Installation

```
$ gem install guideline
```

## Usage
https://github.com/r7kamura/guideline/tree/master/examples

```
$ ruby examples/long_line_checker.rb
spec/guideline/checker_spec.rb
  27: Line length  88 should be less than  80 characters

$ ruby examples/long_method_checker.rb
lib/guideline/checker/long_line_checker.rb
   3: Too long   9 lines method <#check>

lib/guideline/checker/long_method_checker.rb
   6: Too long   9 lines method <#check>
  42: Too long  10 lines method <#on_def>
```
