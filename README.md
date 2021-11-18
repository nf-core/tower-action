# ![nf-core/tower-action](img/nfcore-toweraction_logo.png)

**A GitHub Action to launch a workflow using [Nextflow Tower](https://tower.nf) - <https://tower.nf>.**

## NB: This `master` branch is onlyfor backwards compatability

Because version 2.0 of this action broke backwards compatability, and nf-core pipelines at the time
are set up to use `@master`, this branch contains workarounds to ensure that they keep working.

Going forward, please use `@2` for the latest version under the v2 major release.

If writing a new action, please do not use this `master` branch. Instead see `main` for the latest stable code.

## Example usage

### Minimal example

This runs the current GitHub repository pieline on [Nextflow Tower](https://tower.nf) at the current commit hash when pushed to the `dev` branch. The workflow runs on the user's personal workspace.

```yaml
on:
  push:
    branches: [dev]

jobs:
  run-tower:
    runs-on: ubuntu-latest
    steps:
      - uses: nf-core/tower-action@2
        # Use repository secrets for sensitive fields
        with:
          access_token: ${{ secrets.TOWER_ACCESS_TOKEN }}
```

### Complete example

This example never runs automatically, but creates a button under the GitHub repository _Actions_ tab that can be used to manually trigger the workflow.

It runs on a specified organisation workspace, calls an external pipeline to be run at a pinned versiont tag. The `--outdir` parameter is used to save results to a separate directory in the AWS bucket and the pipeline uses two config profiles.

```yaml
name: Launch on Tower

# Manually trigger the action with a button in GitHub
# Alternatively, trigger on release / push etc.
on:
  workflow_dispatch:

jobs:
  run-tower:
    name: Launch on Nextflow Tower
    # Don't try to run on forked repos
    if: github.repository == 'YOUR_USERNAME/REPO'
    runs-on: ubuntu-latest
    steps:
      - uses: nf-core/tower-action@master
        # Use repository secrets for sensitive fields
        with:
          workspace_id: ${{ secrets.TOWER_WORKSPACE_ID }}
          access_token: ${{ secrets.TOWER_ACCESS_TOKEN }}
          api_endpoint: ${{ secrets.TOWER_API_ENDPOINT }}
          compute_env: ${{ secrets.TOWER_COMPUTE_ENV }}
          pipeline: YOUR_USERNAME/REPO
          revision: v1.2.1
          workdir: ${{ secrets.AWS_S3_BUCKET }}/work/${{ github.sha }}
          # Set any custom pipeline params here - JSON object as a string
          parameters: |
            {
                "outdir": "${{ secrets.AWS_S3_BUCKET }}/results/${{ github.sha }}"
            }
          # List of config profiles to use - comma separated list as a string
          profiles: 'test,aws_tower'
```

## Inputs

Please note that a number of these inputs are sensitive and should be kept secure. We recommend saving them as appropriate using GitHub repository [encrypted secrets](https://docs.github.com/en/actions/reference/encrypted-secrets). They can then be accessed with `${{ secrets.SECRET_NAME }}` in your GitHub actions workflow.

### `access_token`

**[Required]** Nextflow Tower personal access token.

Visit <https://tower.nf/tokens> to generate a new access token.

See the [Nextflow Tower documentation for more details](https://help.tower.nf/getting-started/usage/#via-nextflow-run-command):

![workspace ID](img/usage_create_token.png)
![workspace ID](img/usage_name_token.png)
![workspace ID](img/usage_token.png)

### `workspace_id`

**[Optional]** Nextflow Tower workspace ID.

Nextflow Tower organisations can have multiple _Workspaces_. Use this field to choose a specific workspace.

Default: Your personal user's workspace.

Your Workspace ID can be found in the organisation's _Workspaces_ tab:

![workspace ID](img/workspace_id.png)

Default: Your primary workspace.

### `compute_env`

**[Optional]** Nextflow Tower compute environment name (not ID).

Default: Your primary compute environment.

### `api_endpoint`

**[Optional]** Nextflow Tower API URL endpoint.

Default: `api.tower.nf`

### `pipeline`

**[Optional]** Pipeline repository name.

For example, `nf-core/rnaseq` or `https://github.com/nf-core/sarek`

Default: The current GitHub repository (`github.repository`).

### `revision`

**[Optional]** Pipeline revision.

A pipeline release tag, branch or commit hash.

Default: The current GitHub commit hash (`github.sha`).

### `workdir`

**[Required]** Nextflow work directory.

The location that temporary working files should be stored. Must be accessible in the Nextflow Tower compute environment used.

### `parameters`

**[Optional]** Pipeline parameters.

Additional pipeline parameters.

These should be supplied as a valid JSON object, quoted as a string in your GitHub Actions workflow. See example usage above for an example.

### `profiles`

**[Optional]** Nextflow config profiles.

Pipeline config profiles to use (eg. `-profile test`). Should be a JSON array of strings, quoted as a string in your GitHub Actions workflow. See example usage above for an example.

Default: An empty JSON array (`[]`).

## Credits

This GitHub Action was written by Phil Ewels ([@ewels](https://github.com/ewels)), with help from and based on earlier work by Gisela Gabernet ([@ggabernet](https://github.com/ggabernet)).

## Citation

If you use `nf-core/tower-action` in your work, please cite the `nf-core` publication as follows:

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
