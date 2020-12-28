# Commit with deploy key
Action to commit a file/directory to another repo using a deploy key.

## Example usage
* Create an SSH key pair to use for the commits
* Add the public key to your destination repo as a deploy key with push access
* Add the private key to your source repo as a secret

```yaml
uses: leigholiver/commit-with-deploy-key@v1.0.0
with:
  source: build_output
  destination_folder: dist
  destination_repo: leigholiver/commit-with-deploy-key
  deploy_key: ${{ secrets.DEPLOY_KEY }}
```

## Inputs
### `source`
**Required** The file/directory to commit

### `deploy_key`
**Required** Private SSH key to use for the commit. The public key must be added to the destination repostitory as a deploy key, with push access

### `destination_repo`
**Required** Git repository to push changes to

### `destination_folder`
Directory in the destination repo to push changes to (default `.`)

### `destination_branch`
Branch in destination repo to push changes to (default `main`)

### `delete_destination`
Delete destination directory contents before copy? (default `false`)

### `git_username`/`git_email`
Github user to use for the commit (default: `${{ github.actor }}`)

### `commit_message`
Commit message (default `<action name> from <commit hash>`)

## Outputs
### `commit_hash`
SHA hash of the generated commit
