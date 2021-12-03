# History: Exploring the Past

## Referencing Commits

The `git log` command is a nice way to go through the commit history, but it squashes the history in a linear fashion. With the `--graph` flag we are able to display a more accurate representation.

```
git log --graph --decorate --oneline
* 225f337 (HEAD -> master, hunks) Changed instructions to upper case
*   7dc8ce1 Changed spagetti recipe name
|\
| * fa27cd1 (new_recipe_name) Changed recipe name
* | a8d0f84 Changed recipe name
|/
* 41b523d Changed menu.md formating
* f8c10c5 Changed file format
* 5b8f8ef Rice
* 5496293 (tag: release_1, tag: Spicy_food_release, origin/master, spagetti) Added new spagetti recipe
* 35e20aa Added fish soup recipe
*   6d63607 (ideas) Merge branch 'ideas'
|\
| * c023b15 Tweaked the apple pie recipe
* | 7743c55 Added new ingredients list
|/
* b130b95 Updated menu.txt
* dc8d2aa First commit
```

Let's look for information for a specific commit, with `git show` we have a nice way to see this, we could either do this with a hash code or use a point of reference like HEAD.

```
git show HEAD
commit 225f337e212e1b3d927f9de032845106fe744f62 (HEAD -> master, hunks)
Author: Je12emy <Jeremyzelaya@hotmail.es>
Date:   Fri Aug 13 16:16:45 2021 -0600

    Changed instructions to upper case

diff --git a/recipes/readme.txt b/recipes/readme.txt
index 3000905..a899ffc 100644
--- a/recipes/readme.txt
+++ b/recipes/readme.txt
@@ -1 +1 @@
-Place your recipes in this folder
+PLACE YOUR RECIPES IN THIS FOLDER


git show 225f337
commit 225f337e212e1b3d927f9de032845106fe744f62 (HEAD -> master, hunks)
Author: Je12emy <Jeremyzelaya@hotmail.es>
Date:   Fri Aug 13 16:16:45 2021 -0600

    Changed instructions to upper case

diff --git a/recipes/readme.txt b/recipes/readme.txt
index 3000905..a899ffc 100644
--- a/recipes/readme.txt
+++ b/recipes/readme.txt
@@ -1 +1 @@
-Place your recipes in this folder
+PLACE YOUR RECIPES IN THIS FOLDER
```

We can also use the HEAD as a starting point to explore other commits.

* `HEAD^` show the parent of head
* `HEAD^^` show head's parent's parent.
* `HEAD~2` show to commit down from the head.

This is nice unless we have multiple parents for a commit, a merge.

* `HEAD~2^2` go back two commits from head, and pick the 2nd parent.

There are also other fancier ways.

* `HEAD@{'1 month ago'}`

## Tracking Chanes in History

Let's see how our commits are connected, `git blame` is a nice way to see this. `git blame` displays the commits responsible for altering each line in a file.

```
git blame menu.md
41b523d7 (Je12emy 2021-08-13 13:55:08 -0600 1) # Menu
41b523d7 (Je12emy 2021-08-13 13:55:08 -0600 2)
41b523d7 (Je12emy 2021-08-13 13:55:08 -0600 3) * Apple Pie
41b523d7 (Je12emy 2021-08-13 13:55:08 -0600 4) * Cheese Cake
41b523d7 (Je12emy 2021-08-13 13:55:08 -0600 5) * Fish Soup
fa27cd14 (Je12emy 2021-08-13 15:52:25 -0600 6) * Spagetti and Meatballs.
41b523d7 (Je12emy 2021-08-13 13:55:08 -0600 7) * Rice
```

`git diff` will compare the content of two areas, but it can also be used to see the differences between commits.

```
git diff HEAD HEAD~2
diff --git a/menu.md b/menu.md
index dfdf10e..faf98fc 100644
--- a/menu.md
+++ b/menu.md
@@ -3,5 +3,5 @@
 * Apple Pie
 * Cheese Cake
 * Fish Soup
-* Spagetti and Meatballs.
+* Spagetti with Meatballs
 * Rice
diff --git a/recipes/readme.txt b/recipes/readme.txt
index a899ffc..3000905 100644
--- a/recipes/readme.txt
+++ b/recipes/readme.txt
@@ -1 +1 @@
-PLACE YOUR RECIPES IN THIS FOLDER
+Place your recipes in this folder
```

`git diff` could also be used between branched

```
git diff master notgood
diff --git a/menu.md b/menu.md
deleted file mode 100644
index dfdf10e..0000000
--- a/menu.md
+++ /dev/null
@@ -1,7 +0,0 @@
-# Menu
-
-* Apple Pie
-* Cheese Cake
-* Fish Soup
-* Spagetti and Meatballs.
-* Rice
diff --git a/menu.txt b/menu.txt
```

## Browsing the Log

We have already seen a few extra options for `git log`, let's check some other cases.

The `--patch` shows a small demo for changes between commits.

```
git log --patch
commit 225f337e212e1b3d927f9de032845106fe744f62 (HEAD -> master, hunks)
Author: Je12emy <Jeremyzelaya@hotmail.es>
Date:   Fri Aug 13 16:16:45 2021 -0600

    Changed instructions to upper case

diff --git a/recipes/readme.txt b/recipes/readme.txt
index 3000905..a899ffc 100644
--- a/recipes/readme.txt
+++ b/recipes/readme.txt
@@ -1 +1 @@
-Place your recipes in this folder
+PLACE YOUR RECIPES IN THIS FOLDER
```

The `--grep` allows us to filter commits by name

```
git log --grep apple --oneline
c023b15 Tweaked the apple pie recipe
```

The `-G` flag allows us to filter commits which either added or deleted this word.

```
git log -Gapple --patch
commit 7743c553be78149d03f25a9281f4787a033cff23
Author: Je12emy <Jeremyzelaya@hotmail.es>
Date:   Wed Aug 11 12:07:10 2021 -0600

    Added new ingredients list

diff --git a/recipes/apple_pie.txt b/recipes/apple_pie.txt
index 2399189..40e15d0 100644
--- a/recipes/apple_pie.txt
+++ b/recipes/apple_pie.txt
@@ -1 +1,7 @@
 Apple Pie
+
+pre-made pastry
+1/2 cup butter
+3 tablespoons flour
+1 cup sugar
+8 granny Smith apples
```
We can check the latest commits.

```
git log -3 --oneline
225f337 (HEAD -> master, hunks) Changed instructions to upper case
7dc8ce1 Changed spagetti recipe name
a8d0f84 Changed recipe name
```

Check a range of commits using the head as a reference.

```
git log HEAD~5..HEAD^ --oneline
7dc8ce1 Changed spagetti recipe name
a8d0f84 Changed recipe name
fa27cd1 (new_recipe_name) Changed recipe name
41b523d Changed menu.md formating
f8c10c5 Changed file format
```

We can check the missing commits between branches.

```
git log notgood..master --oneline
225f337 (master, hunks) Changed instructions to upper case
7dc8ce1 Changed spagetti recipe name
a8d0f84 Changed recipe name
fa27cd1 (new_recipe_name) Changed recipe name
41b523d Changed menu.md formating
f8c10c5 Changed file format
5b8f8ef Rice
5496293 (tag: release_1, tag: Spicy_food_release, origin/master, spagetti) Added new spagetti recipe
35e20aa Added fish soup recipe
```
