# Finding your Workflow

When working with other developers there are many considerations we should make with our peers.

-   Distribution Model: How many repositoriries you have? Who can access them?
-   Branching Model: Which branches do you have? How do you usethem?
-   Constrains: Do you merge or do you rebase? Can you push unstable code?

> This is a module about Git workflow patterns.

## Selecting a Distribution Model

There very first thing we should choose is our distribution model, in a peer to peer model, all developers have their own repositories which would cause maintenance nearlly imposible. Projects whith a central or "blessed" repositories is a repository is onto which all developers push and pull code from, this is a Centralized Model.

A twist on the Centralized Model, in which only a few developers may push directly onto the server while other developers known as contributors through pull requests or other mechanisms ask for maintainers to merge their changes, this is known as a Pull Request Model.

Another model where repositories are split into subprojects, with a set of general contributors whom contribute to subprojects which push updates to the main project, this model is known as Dictator and Leitenants Model.

> Many projects use a mixed Distribution Model.

## Designin Branches

Every project has a policy for managing branches, we should diferenciate between stable and unstable branches. a stable is ready for production while a unstable branch may be broken. We may find a branch onto which other branches diverge from. A release branch is really usefull to make sure changes are always ready for release.

## Setting Constrains

These are global rules for each repository.

-   Using rebase or merge.
-   Commit permisions, into each branch should each developer commit to.
-   Other rules like not pushing into a red build

It's up to us to enforce this rules and these rules should be constent between commits.

## Gitflow

GitFlow is a general guide for we should structure our branches and it provides several constrains, while this is a nice and well structured solution, it isn't perfect and we should consider many factors before using any preexisting workflow on our project.

## Growing a Workflow

We should overtime develop our own workflow, start simple and allow new rules to be added or removed overtime.
