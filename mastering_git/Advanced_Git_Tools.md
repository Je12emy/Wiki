[#](#) The Four Areas: Advanced Tools

## Stashing Data

We are finally going to talk about the 4th area in Git, the Stash. So far all the commands we have seen do not affect the stash, since there is only one command which can affect it, the `git stash` command. The Stash is an area which is only affected when we want it to, it's easier to visualize it as a secure clip board onto which we store our changes if we need to work if we need to work on another branch.

Supose we need have some work in the main branch but we need to work on another branch for a bit and we don't want to commit our changes yet, in this case using the stash is ideal.

```
git status
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   menu.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   recipes/apple_pie.txt
```

To store our current work in the stash we need to use the `git stash` we can provide the default flash `--save`, as a consideration this command will not stash non stagged changes, so providing the `--include-untracked` will also save the working area in the stash.

```
git stash --include-untracked
Saved working directory and index state WIP on master: f8c10c5 Changed file format
```

This will leave us on a clean state too.

```
git status
On branch master
nothing to commit, working tree clean
```

Let's check the contents of the stash.

```
git stash list
stash@{0}: WIP on master: f8c10c5 Changed file format
```

From here on out, we could work on another branch and our previous changes would be stored safelly in the stash. When we are ready to continue working on the main branch we can reapply thoese changes.

```
git stash apply stash@{0}
```

This will bring back those changes, for us to keep working or just commit them. To clear this stash we use `git stash clear`

```
git stash list
stash@{0}: WIP on master: f8c10c5 Changed file format
stash@{1}: WIP on master: f8c10c5 Changed file format
stash@{2}: WIP on master: f8c10c5 Changed file format

git stash clear

git stash list
```

## Solving Conflicts

Conflicts arise when Git finds out the same line in a file has been modified by both branches and it doesn't which version to keep nor how to mix them. Git knows a conflicts has ocurred because two new files are created to indicate which branches are being merged.

```
git status
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
	both modified:   menu.md

no changes added to commit (use "git add" and/or "git commit -a")

MERGE_HEAD  MERGE_MODE  MERGE_MSG  
```

In here `MERGE_HEAD` is a temporary reference to the current merge and it contains information about the branch to be merged.

```
cat .git/MERGE_HEAD
fa27cd1427ec53d0b2f1a8740db6ac2e30ea9ea5

git show fa27cd1427ec53d0b2
commit fa27cd1427ec53d0b2f1a8740db6ac2e30ea9ea5 (new_recipe_name)
Author: Je12emy <Jeremyzelaya@hotmail.es>
Date:   Fri Aug 13 15:52:25 2021 -0600

    Changed recipe name

diff --git a/menu.md b/menu.md
index a095ab9..dfdf10e 100644
--- a/menu.md
+++ b/menu.md
@@ -3,5 +3,5 @@
 * Apple Pie
 * Cheese Cake
 * Fish Soup
-* Spagetti
+* Spagetti and Meatballs.
 * Rice
```

Once we solve this conflicts, we need to tell git the conflict has been resolved with the Index Area, since the Index area in incharge of telling git which information goes into the next commit. 

## Working with Paths

We can perform undo operations with file paths, supose we have changes in the menu at the root of the project and at the instrucions inside the recipes folder.

```
git status
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   menu.md
	modified:   recipes/readme.txt
```

In here we want to unstage changes only on the menu file, this can be done with the `git reset` command on the file itself.

```
git reset  HEAD menu.md
Unstaged changes after reset:
M	menu.md

git status
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   recipes/readme.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   menu.md
```

Now let's remove the menu changes on the working area, while we might think this could be posible with the `--HARD` flag on that single file, Git does not allow to use it with file paths. In this case we will use `checkout`. Normally `checkout` would move the HEAD reference to another branch and copy over the files from the Repository into the index and working area but in this case, it will copy over the files from the current commit into the working area and index for the specified file.

```
git checkout HEAD menu.md
Updated 1 path from 35dd8d3

git status
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   recipes/readme.txt
```

This type of checkout is actually really destructive, since we had no warning before we wipped our changes in the working and index areas.

## Commiting Parts of a File

So far we have trated files as a single unit to be managed in Git, actually we can be as granular as we need so with single lines of code. Let's work on commiting lines of code, for this example we will be working on another branch.

If we where to stage a file, with the `--patch` flag we are able to specify which hunks we would like to stage.

```
git add --patch menu.md
diff --git a/menu.md b/menu.md
index dfdf10e..f94988c 100644
--- a/menu.md
+++ b/menu.md
@@ -1,7 +1,7 @@
 # Menu

-* Apple Pie
+* Apple Piece
 * Cheese Cake
 * Fish Soup
 * Spagetti and Meatballs.
-* Rice
+* White Rice
(1/1) Stage this hunk [y,n,q,a,d,s,e,?]?
```

By pressing the ? mark we can check which options are available.

```
(1/1) Stage this hunk [y,n,q,a,d,s,e,?]? ?
y - stage this hunk
n - do not stage this hunk
q - quit; do not stage this hunk or any of the remaining ones
a - stage this hunk and all later hunks in the file
d - do not stage this hunk or any of the later hunks in the file
s - split the current hunk into smaller hunks
e - manually edit the current hunk
? - print help
```

In this case these hunks are still to big and we want to go on a line by line basis, with the s options we can split this hunks even further. Let's stage only this hunk
```
 # Menu

-* Apple Pie
+* Apple Piece
 * Cheese Cake
 * Fish Soup
 * Spagetti and Meatballs.
(1/2) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]? y
@@ -4,4 +4,4 @@
 * Cheese Cake
 * Fish Soup
 * Spagetti and Meatballs.
-* Rice
+* White Rice
(2/2) Stage this hunk [y,n,q,a,d,K,g,/,e,?]? n
```
If we check the status, we will see that the file is both staged and unstaged.

```
git status
On branch hunks
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   menu.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   menu.md
```

Let's check with `diff` between the index and repository areas.

```
git diff --cached
diff --git a/menu.md b/menu.md
index dfdf10e..2a23975 100644
--- a/menu.md
+++ b/menu.md
@@ -1,6 +1,6 @@
 # Menu

-* Apple Pie
+* Apple Piece
 * Cheese Cake
 * Fish Soup
 * Spagetti and Meatballs.
```

## Git Switch and Restore

These are two experimetals commands which aim to split the functionallity from checkout in moving between branches and restoring changes from the current commit, restore is a nice way to unstage files.

