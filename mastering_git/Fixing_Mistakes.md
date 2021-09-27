# History Fixing Mistakes

## Reviewing the Golden Rule

Let's look at some tools for altering our project history, like cleaning up local commits. Just as we saw in th previous course, [rebasing](../how_git_works/Rebasing_Made_Simple) is a nice tool at our disposal but we should never rebase shared commits, since it is a command which creates new commits which may cause old commits to be unreachable. This rule applies for all tools we are going to view in this module.

## Changing the Latest Commit

The first way to fix the latest commit, supose we forgot to add some changes after we made a commit. If we have already commited some changes and we have a related fix, we could use the `--amend` flag when commiting.

```
git commit --amend
```

This will tell git to clone the latest commit with our stagged changes, this means the old commit will be subject to garbage collection.

## Navigating Interactive Rebases

With an intereactive rebase we are able to fix and rewrite our project history, to use it simply use the `-i` or `--interactive` flag with a exclusive point of reference, since we are following the rule of not touching shared commits we will use `origin/master`.

In this case first, check the origin project history.

```
git log --oneline
1a3b87d (HEAD -> master) Add homemade pizza recipe
225f337 (hunks) Changed instructions to upper case
7dc8ce1 Changed spagetti recipe name
a8d0f84 Changed recipe name
fa27cd1 (new_recipe_name) Changed recipe name
41b523d Changed menu.md formating
f8c10c5 Changed file format
5b8f8ef Rice
```
With a rebase we are able to tell Git how we would like to rewrite it.

```
reword 5b8f8ef Rice
pick f8c10c5 Change menu file format
squash 41b523d Changed menu.md formating
pick a8d0f84 Change spagetti recipe name
squash fa27cd1 Changed recipe name
pick 225f337 Change README instructions to upper case
pick 1a3b87d Add homemade pizza recipe

# Rebase 5496293..1a3b87d onto 5496293 (7 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified). Use -c <commit> to reword the commit message.
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
```

The rebase program will ask us for input when squashing commits since a new commit message is needed and if any conflicts where to require our manual asistance.

Here we just need to pick or write a commit message.

```
# This is a combination of 2 commits.
# This is the 1st commit message:

Changed file format

# This is the commit message #2:

Changed menu.md formating

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Fri Aug 13 12:11:21 2021 -0600
#
# interactive rebase in progress; onto 5496293
# Last commands done (3 commands done):
#    pick f8c10c5 Change menu file format
#    squash 41b523d Changed menu.md formating
# Next commands to do (4 remaining commands):
#    pick a8d0f84 Change spagetti recipe name
#    squash fa27cd1 Changed recipe name
# You are currently rebasing branch 'master' on '5496293'.
#
# Changes to be committed:
#	new file:   menu.md
#	deleted:    menu.txt
#
```

Here a merge conflict ocurred.

```
git rebase origin/master -i
[detached HEAD 518dfef] Add rice recipe
 Date: Thu Aug 12 12:21:18 2021 -0600
 1 file changed, 1 insertion(+)
[detached HEAD e4dd0f2] Change menu file format and add format fixes
 Date: Fri Aug 13 12:11:21 2021 -0600
 2 files changed, 7 insertions(+), 5 deletions(-)
 create mode 100644 menu.md
 delete mode 100644 menu.txt
Auto-merging menu.md
CONFLICT (content): Merge conflict in menu.md
error: could not apply fa27cd1... Changed recipe name
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply fa27cd1... Changed recipe name
```

After fixing the merge conflict, we just need to provide the `--continue` flag

```
git add menu.md

git rebase --continue
```

This is now our new commit history.

```
git log --oneline
a2b1628 (HEAD -> master) Add homemade pizza recipe
a84e487 Change README instructions to upper case
69d491a Change Spagetti recipe name
e4dd0f2 Change menu file format and add format fixes
518dfef Add rice recipe
```

## Browsing the Reflog

Mistakes may be commited during a rebase, this means commits may get lost and garbage collected. Thanks to the `reflog` we are able to view a local log for all HEAD movements in our repository. 

```
git reflog
a2b1628 (HEAD -> master) HEAD@{0}: rebase (finish): returning to refs/heads/master
a2b1628 (HEAD -> master) HEAD@{1}: rebase (pick): Add homemade pizza recipe
a84e487 HEAD@{2}: rebase (reword): Change README instructions to upper case
8f27085 HEAD@{3}: rebase: fast-forward
69d491a HEAD@{4}: rebase (start): checkout HEAD~2
```

We could then checkout into a specific hash and put a branch on it in order to avoid loosing this commitWe could then checkout into a specific hash and put a branch on it in order to avoid loosing this commit..

## Rewriting Large Chunksof History

The most common use case for writting a large history is when we end up commiting large files in the history, another case is where we commit important credentials like `.env` variables. The command `filter-repo` allows us to remove a file from the entire project history, this is pretty much a nuclear options which will cause a ton of problems for all peers.

In here we are telling Git to remove menu.md from the entire project history.

```
git filter repo --path menu.md --invert-paths
```

## Reverting Commits

`git revert` is a command which allows us to do the opposite which a commit has done by giving it a hash it will revert the changes made by that commit.
