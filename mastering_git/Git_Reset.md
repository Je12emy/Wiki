# The Four Areas: Git Reset

## Understanding Reset

This is one of Git's most usefull commands, this may be a confusing command so we need to understand some key concepts first.

* To understand reset, you need to understand the 3 main Areas and Git's branches.
* Reset does different things in different contexts.

First let's remember which commands move branches.

* commit moves the branch to point towards a new commit.
* merge creates new commits.
* rebase creates new commits.
* pull fetches and merges the local commits with the remote's commits.

These are commands which as a side effect, move the branch, but `reset`'s main purpose is to move the branch. Reset just moves a branch (the current branch) which points towards a commit. Depending on the flags we give when using `git reset` it will move the branch in different ways with the `--hard` flag it will copy the data from the new current commit into the index and working area, with `--mixed` it will copy data from the repository into the Index (this is the defaut options) and `--soft` will not affect the Index nor the Working Area.

## A Reset Example

Supose we added a new commit like so.

```
commit cd7843e44c9f556ecf6d346b5d55dfd19fe22555 (HEAD -> master)
Author: Je12emy <Jeremyzelaya@hotmail.es>
Date:   Fri Aug 13 12:41:16 2021 -0600

    Added strawberry squid to menu
commit f8c10c5a19a4f32e867f4aadc8e0fcda68e9e23a
Author: Je12emy <Jeremyzelaya@hotmail.es>
Date:   Fri Aug 13 12:11:21 2021 -0600

    Changed file format
```

But we actually regret doing this change, and we wish to go back to a state in which we did not do this changes. In this case `git reset --hard` is ideal if we are sure those changes should be revereted.

```
git reset --hard f8c10c5a19a4f3
HEAD is now at f8c10c5 Changed file format
```

This will move the branch into this specific commit, and the previous child commits will be subject to garbage collection. Remember the `--hard` flag will copy the contents of the repository into the index and the working area.

## More Reset Examples

If we stage some changes, there's a few ways in which we could unstage these changes, we've already seen the [[The Four Areas: Basic Workflow#Removing Files|git rm command]], actually Git itselft recommends the `reset HEAD` command (on earlier versions) where the commit onto which the HEAD is pointing to copy it's contents which the `reset` command. Here we may apply the same flags we've already seen, in this case let's undo all our changes, so a `--hard` flag should be ok.

```
git status
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   menu.md
```

```
git reset --hard HEAD
```
