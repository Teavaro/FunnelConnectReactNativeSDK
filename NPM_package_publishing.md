## Development:

1. Run The following script depending on which OS you are using: 
   - Linux   => `scripts/scripts_runner.sh` 
   - MAC     => `scripts/scripts_runner.command`
   - Windows => `scripts/scripts_runner_windows.bat`

## Publish a new version to NPM

1. Commit new changes to the master or create a BR from the develop branch to the master branch.
2. Increment the package version in the `package.json` file (the new version of the npm package).
3. Open the `release_notes.properties` file and write the release description value after the equal sign of the `DESCRIPTION` property.
4. Push the changes to the master branch.
5. A new GitHub release will be created and a new tag will be created automatically with the tag number matching the npm version you updated in step 2.
6. A GitHub action will trigger to create a new GitHub release.
7. Another GitHub action will trigger to deploy a new version to npm (The trigger of this action is the success of the previous GitHub action).