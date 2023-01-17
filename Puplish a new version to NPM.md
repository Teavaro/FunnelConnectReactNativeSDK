## 

1. Commit new changes to the master or create a BR from the develop branch to the master branch.
2. Create a new git tag but do not push it.
3. Open the release_notes.properties file and write the release description value after the equal sign of the DESCRIPTION property.
4. Push the new changes to the master branch without pushing the new git tag.
5. A new GitHub release will be created and a new tag will be created automatically with the tag number you created in step 2.
6. A GitHub action will trigger to deploy a new version to NPM.