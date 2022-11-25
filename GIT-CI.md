# Git Propose Changes

Steps to introduce new changes to the project repository:
  
1. [Git Clone the project](https://github.com/git-guides/git-clone)
   - The `git clone` command is used to create a copy of a specific repository or branch within a repository.
   - HTTPS Example: `git clone https://github.com/Call-for-Code/Agrolly-Web.git`
   - SSH Example: `git clone git@github.com:Call-for-Code/Agrolly-Web.git`
   
2. [Create a branch](https://github.com/git-guides/#create-a-branch)
   - Create a new local branch from the `main/master` branch of the project to make your changes.
   - Example: `git checkout -b <branch name>`
  
3. [Make Code/File Changes](https://github.com/git-guides/#make-change-and-make-a-commit)
   - Add/Update your changes to the project.
    
4. [Git Status](https://github.com/git-guides/git-status)
   - `git status` command shows the current state of your Git working directory and staging area.
   
5. [Git Add](https://github.com/git-guides/git-add)
   - The `git add` command adds new or changed files in your working directory to the Git staging area.
   - Example:
     - Add all changes: `git add .`
     - Add specific file changes: `git add <dynamic file path>`

6. [Git Commit]()
   - `git commit` creates a commit, which is like a snapshot of your repository. These commits are snapshots of your entire repository at specific times. You should make new commits often, based around logical units of change. Over time, commits should tell a story of the history of your repository and how it came to be the way that it currently is. Commits include lots of metadata in addition to the contents and message, like the author, timestamp, and more.
   - Example: `git commit -m "adding new changes"`

7. **Merge latest `main` branch changes**
    - Checkout to `main` branch and pull latest changes
      - `git checkout main`
      - `git pull`
    - Merge `latest `main` branch changes
      - `git checkout <branch name>`
      - `git merge main`

8. [Git push](https://github.com/git-guides/git-push)
    - `git push` uploads all local branch commits to the corresponding remote branch.
    - For a new local branch which is still not in the central repository use the command `git push -u origin <branch name>` to push your changes for the very first time. Then after you use just `git push` command to push your changes for the same branch.

9.  [Create Pull Request (PR)](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
    - Create a pull request to propose and collaborate on changes to a repository. Check the [link](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request#creating-the-pull-request) to learn on how to create a PR for your changes in your branch.
    - Add a reviewer to your pull request.