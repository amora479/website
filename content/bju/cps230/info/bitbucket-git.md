---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Introduction to Git and Bitbucket

Git is an industry standard source control tool, and Bitbucket is one of the common industry standard git hosts.  Being familiar with these tools will not only give you a leg up when interviewing for internships or industry positions, but the tools will also help you in your later classes with managing semester long projects.

## Getting Setup

First, create an account on [Bitbucket](https://bitbucket.org).  You can use any email address you like to sign up with, however, please associate your BJU student email with your account if you choose to sign up using your personal email.  To do so, click the user icon in the lower left of the screen then select Bitbucket Settings.  You can add additional emails to your account under Email Aliases.

Associating your student email gives you unlimited private repositories for as long as your student email remains valid, but you are not required to associate your BJU email with the account.

## Accepting the Invitation

You will be receiving an email from the instructor via [Bitbucket](https://bitbucket.org) letting you know that you have been given access to a repository.

![Bitbucket Signup](/bju/cps230/info/bitbucket-git-images/signup.png)

If you receive an invitation instead, you have not associated your BJU email with your bitbucket account. You can either associate the email with your account then accept the invitation or just accept the invitation (you are not required to associate your BJU email with the account).

## Installing Git

There are multiple ways to go about installing git.  To really become familiar with Git, we are going to be using it from the command line to start with.  After you are comfortable with command line git, feel free to install any of the GUI tools that are available ([Fork](https://git-fork.com/), [SourceTree](https://www.sourcetreeapp.com/), and [Kraken](https://www.gitkraken.com/) are all excellent options and have free versions; [Tower](https://www.git-tower.com/windows) is an excellent paid tool).

To install command line git, download the installer from [Git SCM](https://git-scm.com/) and follow the instructions in the installer.  When asked how your want to checkout and commit, select "Checkout As Is, Commit Unix-Style". All other defaults are fine.

This will install two tools, `Git Bash` and `Git CMD`.

## Getting a Local Copy of your Repository

Now we're all set.  To get a local copy of the repository, use `cd Documents` to navigate to your documents folder. Back in Bitbucket, click the bucket icon to return home, then click Repositories.  Click on your 230 repository (it will be your BJU username).  In the upper right corner, there will a `Clone` button.  Click it to bring up the following dialog.

![Bitbucket Clone](/bju/cps230/info/bitbucket-git-images/dialog.png)

Change the dropdown to HTTPS if it has SSH selected. Copy the command in the window and paste it into `Git Bash`.  After you paste, press enter to execute.

You should have a window appear asking for your credentials.

![Bitbucket Clone](/bju/cps230/info/bitbucket-git-images/credentials.png)

Enter your credentials and it should complete the copy (it may request your password one more time depending on which version of windows you are using).

If you open `File Explorer` and go to your documents folder, you will now see your repository.  Note that any changes you make to this folder are tracked, but they aren't automatically submitted like Dropbox.  Instead, you have control over what gets submitted to the server and when.

## Submitting a Change

To submit a change, first put your submission into the folder for that assignment.  Now open `Git Bash` and use `cd` to navigate to the repository (i.e. `cd Documents/<bju username>`).

Use the command `git status` to see what changes are pending.

![Bitbucket Clone](/bju/cps230/info/bitbucket-git-images/pending.png)

To add folders and files, use the `git add <file or folder name>` command.  Once you have added all of the files and folders you want to add for this submission, use the `git commit -m "<short description of what your submitting>"` command to create a milestone, or a commit.

You can create as many commits as you want.  They are actually extremely helpful because you can revert the files back to any commit you want rather easily.  For example, if you create a commit at the end of the B-level version of a project then attempt but totally botch the A-level version, you can revert back to the B-level version very easily. (Use Google to lookup `git log` and `git revert` if you need to do this, or come see the instructor).

You've created a commit, it is not sent to the server automatically.  Instead you can create a bunch of commits locally over the course of several days, then just push them all to the server at once using `git push origin`.

Sometimes, particularly in group projects, someone will submit a commit to the repository before you do.  If this happens you'll get an error message stating `The remote contains work that you do not have locally`.  This simply means that you need to download the commits made by the instructor or your partner before you can submit yours.

To download the commits you don't have, use the `git pull origin` command.  This will generally open Vim with a prewritten commit message for you.  Just use `<Esc>:wq` to exit.  Then try `git push origin` again.

## Rare Situations

This will likely not be an issue for your own repository, but it might be an issue for your group projects.  If two people edit the same file, an issue can arise known as a merge conflict.  This means that when git downloaded the server changes, one of those commits changed a line that you also changed.  You'll need to figure out which version of the line is correct before you can move on.  Git will not let you push while conflicts exist.

To see which files are conflicted, use `git status`.  Open this files in an editor, and you'll notice areas surrouneded by less than and greater than signs.  These areas contain your changes as well as the changes made by others.  Consolidate the change into one (removing the less than and greater than signs) then use `git add` to mark the file as no longer conflicted.

If you need help resolving a merge conflict, Google and the instructor are your friend.