# Introduction

This project uses git for development, i.e. for *pull requests* and the review of such code.


## Issue or bug reports and discussions

Issue or bug reports are created and reviewed on the [issues tracker](https://github.com/alexisph/pvpaR/issues).


## Pull Requests

Before [creating a pull request](https://help.github.com/articles/creating-a-pull-request/), please read our general code guidelines:

- When indenting your code, use **two** spaces. Never use tabs or mix tabs and spaces.
- Place spaces around all infix operators (=, +, -, <-, etc.). The same rule applies when using = in function calls.
- File names should be meaningful and end in .R. If files need to be run in sequence, prefix them with numbers.
- Variable and function names should be **lowercase**. Use an **underscore** (_) to separate words within a name. Generally, variable names should be nouns and function names should be verbs. Strive for names that are concise and meaningful.
- An opening curly brace should never go on its own line and should always be followed by a new line. A closing curly brace should always go on its own line, unless it’s followed by else.
- Use <-, not =, for assignment.
- Comment your code. Each line of a comment should begin with the comment symbol and a single space: #. Comments should explain the why, not the what.

### General guidelines for creating pull requests:

- **One pull request per feature**. If you want to do more than one thing, send multiple *pull requests*.
- **Send coherent history**. Make sure each individual commit in your *pull request* is meaningful.

### Please follow these guidelines; it's the best way to get your work included in the project!

- [Click here](https://github.com/alexisph/pvpaR) to **clone** the project
- If you cloned a while ago, get the latest changes from upstream:

```bash
# Fetch upstream changes
git fetch upstream
# Make sure you are on your 'master' branch
git checkout master
# Merge upstream changes
git merge upstream/master
```

- Create a new topic branch to contain your feature, change, or fix:

```bash
git checkout -b <topic-branch-name>
```

- Commit your changes in logical chunks. Use git's [interactive rebase](https://help.github.com/articles/interactive-rebase) feature to tidy up your commits before making them public. Read [this](https://www.atlassian.com/git/tutorials/merging-vs-rebasing/workflow-walkthrough) for an analysis of when to merge and when to rebase a branch.
- [Create a patch](https://ariejan.net/2009/10/26/how-to-create-and-apply-a-patch-with-git/) or a [pull request](https://help.github.com/articles/creating-a-pull-request/) with a clear title and description.
