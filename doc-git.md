# Example of git commands
There are two types of git repositories.
1. Local repo: only access on the working computer. It's everything in the directory on the working computer
2. Remote repo: on the remote server. You can access to anywhere

There are many tutorials and examples how to use git, e.g.,
- https://www.simplilearn.com/tutorials/git-tutorial/git-commands
  
# Frequently used commands
- ```git clone``` download the repo from the remote server to your computer
- ```git checkout`` switch branch
	Checkout an existing branch ```git checkout <branch_name>```
	Checkout and create a new branch with that name ```git checkout -b <branch_name>``
		This will only create the branch on your local repo only. You won't see this new branch on the github website
		until the branch is pushed to the remote server.
- ```git status``` tells the current state of the repository.
- ```git add``` add any new or modified files
- ```git commit -m <message>``` save changes to the local repository. A useful short message will help everyone understand what has happened.
- ```git push``` transfer the commits or pushing the content from the local repository to the remote repository.
	```git push -u origin <branch_name>```

- ```git branch``` determine what branch the local repository is on.
	```git branch -r``` list all branch names on the remote.

- ```git pull``` fetch and merge changes from the remote repository to the local repository.
- ```git merge``` combines the changes from one branch to another branch. 

## example

### CASE 1: create new branch and update to the server

	git checkout -b tsatta/test
	git commit -m 'new branch: tsatta/test'
	git push -u origin tsatta/test

- On the website, you should be able to see your new branch.
- Suggest for naming the branch: user/branch_name

### CASE 2: Merging in (upstream) changes from the main branch into your pre existing branch
To get all updates from main branch to your branch

1. Make sure that you're on your local branch: ```git branch```
	if not, ```git checkout <your branch>```

2. Do a pull within your repository folder so that the development branch is up to date
	``` git pull ```

3. initiate the merge 
	``` git merge origin/main ```

4. You will be navigated to the commit message. Accept the message and exit.
5. Now push the commit to GitHub.
	``` git push -u origin <your branch> ```



