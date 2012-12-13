# Guideline
Guideline checks that your code is protecting the rule of coding guideline.  
This library requires Ruby 1.9 or later.

## Feature
* For each method
 * Check ABC-complexity
 * Check the number of lines
 * Check unused method
* For each file
 * Check the precense of hard tab indent
 * Check the presense of comma at the end of multiline Hash literal
 * Check the horizontal length of each line

## Install
```
$ gem install guideline
```

## Usage
```
$ guideline --help
Usage: guideline [options]
        --no-abc-complexity          (default: true) check method ABC complexity
        --no-hard-tab-indent         (default: true) check hard tab indent
        --no-hash-comma              (default: true) check last comma in Hash literal
        --no-long-line               (default: true) check line length
        --no-long-method             (default: true) check method height
        --no-trailing-whitespace     (default: true) check trailing whitespace
        --no-unused-method           (default: true) check unused method
        --abc-complexity=            (default:   15) threshold of ABC complexity
        --long-line=                 (default:   80) threshold of long line
        --long-method=               (default:   10) threshold of long method
        --path=                      (default:   ./) checked file or dir or glob pattern
```

```
$ guideline --path /path/to/chatroid

lib/chatroid/adapter/campfire.rb
  26: Line length  85 should be less than  80 characters

lib/chatroid/adapter/twitter/event.rb
  48: Line length  87 should be less than  80 characters

spec/chatroid/adapter/twitter/event_spec.rb
  49: Line length  81 should be less than  80 characters

spec/chatroid/adapter/twitter_spec.rb
  30: Line length  85 should be less than  80 characters

lib/chatroid/adapter/twitter.rb
  19: Too long  12 lines method <#stream>
```

```
$ guideline --path /path/to/guideline

lib/guideline/checkers/abc_complexity_checker.rb
  40: ABC Complexity of method<Guideline::AbcComplexityChecker::Moduleable.included> 16 should be less than 10

lib/guideline/error.rb
   5: Remove unused method <render>
```
