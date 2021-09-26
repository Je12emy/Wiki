# Distributed Version Control

Now we should remember our computer is not the only computer in the world and most of the time we will be using Git alonside other developers, let's learn why Git is a Distributed Version Control System.

## A World of Peers

In most cases our repository will be hosted in a remote server, like Github. Here we can generate a copy wich also pulls the `.git` repository though it will only copy one branch. Though we are not forced to use a single source of truth, all clones are peers.

## Local and Remote

We we execute the `git clone` clone a special file is created in the `.git` directory is modified. The `config` file holds information about other copies of the same peers, these are named remotes. A default remote is always created named origin. To synchronize Git needs a way to know the current state for the origin, Git does stores this information.


```
git branch --all
  ideas
* master
  notgood
  spagetti
  remotes/origin/master
```

Even in the refs folder we will find a new directory for remote branches.

```
tree refs/
refs/
├── heads
│   ├── ideas
│   ├── master
│   ├── notgood
│   └── spagetti
├── remotes
│   └── origin
│       └── master
└── tags
    ├── release_1
    └── Spicy_food_release

4 directories, 7 files
```

Though all branches are not here, missing branches will be packed into another file named `packed-refs`.

> Like a local branch, a remote branch is just a reference to a commit.

Since we can't pick inside some of this branches since they are compressed, the could use the `git show-ref master` which shows all branches with a given name.

```
git show-ref master
5496293cf65feeabddeb72359a3b466efc3fbedc refs/heads/master
5496293cf65feeabddeb72359a3b466efc3fbedc refs/remotes/origin/master
```
## The Joy of Pushing

Since each object is a hash, in distributed control system we will see why each hash is unique. When we push our code, Git will not get confused with the new objects since each object is unique and is unmmutable which will allow it to copy those objects. When we make a new change in our local repository, the local head will push into a new commit which does not exist in the remote repository, when we do a push, this commit is cloned in the remote repository.

## The Chore of Pulling

When other peers push into the remote repository things may get complicated, since file conflicts may occur. We may solve this problem by using `git push -f` where local changes for others may get conflicts and their branches may get garbage collected, this is a bad idea. Another option is to use `git fetch` which will create the remote objects in the local repository, then we solve the remote and local changes and push eventually push the resolved conflicts, the command which fetches and merges the remote and local changes is `git pull`.

## Rebase Revisited

Let's see why rebasing is a tricky tools to use, if we rebase locally two branches the history between the local and remote repositories may not match and even the old objects which where coppied by rebase will get garbage collected. We already viewed how to solve merge conflicts by fetching and merging but this will create another identical commit which may cause duplications.

[git_rebase_warning](resources/git_rebase_warning.png)

> Never rebase shared commits.

## Getting Social

There are features which are provided by Github which are not native to Git, an example is `fork`, which is a remote clone from another projects. This is done since we may not have write permisions on the original projects, this allows us to work on our own version. Usually another remote is created in this cases named upstream, which points towards the original project. To merge those changes, git allows us to create `pull requests` which allows upstream to merge our origin's changes.
