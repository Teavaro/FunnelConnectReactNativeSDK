## Development:

1. Run The following script depending on which OS you are using: 
   - Linux   => `scripts/scripts_runner.sh` 
   - MAC     => `scripts/scripts_runner.command`
   - Windows => `scripts/scripts_runner_windows.bat`

## Publish a new version to NPM

1. Commit new changes to the main or create a PR from the develop branch to the main branch.
2. Increment the package version in the `package.json` file (the new version of the npm package).
3. Push the changes to the main branch. The tag will be created automatically before the push, matching the `package.json` version.
4. A GitHub action will trigger to deploy a new version to `npm` (the package published by this action will take the version after `package.json`, matching the latest tag).
