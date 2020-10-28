# pull_request_another_repository
This GitHub Action copies a folder from the current repository to a location in another repository and create a pull request

# Example Workflow
    name: Push File

    on: push

    jobs:
      pull-request:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout
          uses: actions/checkout@v2

        - name: Generate test folder
          run: |
            mkdir target
            echo "test file content" > target/test.md

        - name: Pull Request folder
          uses: fernandodpcarvalho/pull-request-another-repo@main
          env:
            API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
          with:
            source_folder: 'target'
            destination_repo: 'fernandodpcarvalho/teste-github-actions'
            destination_folder: 'test'
            destination_branch: 'pull-request-test'
            user_email: 'fernandodpcarvalho@gmail.com'
            user_name: 'fernandodpcarvalho'

# Variables
* source_folder: The folder to be moved. Uses the same syntax as the `cp` command. Incude the path for any files not in the repositories root directory.
* destination_repo: The repository to place the file or directory in.
* destination_folder: [optional] The folder in the destination repository to place the file in, if not the root directory.
* user_email: The GitHub user email associated with the API token secret.
* user_name: The GitHub username associated with the API token secret.
* destination_branch: The branch of the source repo to update. Can't be main or master.

# Behavior Notes
The action will create any destination paths if they don't exist. It will also overwrite existing files if they already exist in the locations being copied to. It will not delete the entire destination repository.
