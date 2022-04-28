# Commit with deploy key
Action to commit a file or directory to another repo using a deploy key.

## Usage
* Create an SSH key pair to use for the commits
* Add the public key to your destination repo as a deploy key with write access
* Add the private key to your source repo as a secret
* Add this action to your workflow:
```yaml
uses: leigholiver/commit-with-deploy-key@v1.0.3
with:
  source: build_output
  destination_folder: dist
  destination_repo: leigholiver/commit-with-deploy-key
  deploy_key: ${{ secrets.DEPLOY_KEY }}
```

## Inputs
| Name                 | Required | Default                            | Description                                             |
|--------------------- |--------- |----------------------------------- |---------------------------------------------------------|
| `source`             | `true`   |                                    | The file/directory to commit                            |
| `deploy_key`         | `true`   |                                    | Private SSH key to use for the commit. The public key must be added to the destination repostitory as a deploy key, with push access |
| `destination_repo`   | `true`   |                                    | Git repository to push changes to                       |
| `destination_folder` | `false`  | `.`                                | Directory in the destination repo to push changes to    |
| `destination_branch` | `false`  | `main`                             | Branch in destination repo to push changes to           |
| `delete_destination` | `false`  | `false`                            | Delete destination directory contents before copy?      |
| `git_username`       | `false`  | `${{ github.actor }}`              | Github user to use for the commit                       |
| `git_email`          | `false`  | `${{ github.actor }}`              | Github user to use for the commit                       |
| `commit_message`     | `false`  | `<action name> from <commit hash>` | Commit message                                          |

## Outputs
| Name          | Description                      |
|---------------|----------------------------------|
| `commit_hash` | SHA hash of the generated commit |
