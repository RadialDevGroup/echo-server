1. Pick an issue from github issues for the project, assign it to yourself it and label it in-progress.

    Example:

    > `#1` - It should be possible to add an item to a session, by id.

2. Create a local branch in your development environment to work on the story.

    Example:
        $ git fetch
        $ git branch 1-add-item-to-session
        $ git checkout 1-add-item-to-session

3. Create a feature spec for your feature.

   touch /spec/features/add_item_to_session_spec.rb

4. Implement your feature and satisfy relevant test(s).
5. Repeat 3 and 4 as needed.

    WIP-commit as needed, too -- preferably after a 4 iteration.

6. Run the entire test suite.

    ```
    $ bundle exec rspec spec
    ```

5. Commit branch, push to GitHub.

    *I recommend you use a visual git program such as GitX* ~ Ben

6. Create a pull request using the template.

    Use `master` as the root branch`

    See [PULL_REQUEST_TEMPLATE.md](PULL_REQUEST_TEMPLATE.md)

    Merge master into branch and resolve conflicts as needed before PR review if
    it is not automatically mergeable without conflicts.

7. Ask someone to review your code, preferably using Email, or slack, if available

8. Make any necessary changes.

    Address PR review comments. Any ignored comments should be discussed.

9. Repeat 7 and 8 as needed.

10. Request code merge.

    All code will be merged by @mrgenixus
